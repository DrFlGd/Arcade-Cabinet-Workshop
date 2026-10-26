import { parseParams, scadLiteral } from "./params.js";
import { MONITORS, activeArea } from "./monitors.js";
import { parseSvgPaths, splitByLayout, partSvg } from "./outlines.js";
import { Viewer } from "./viewer.js";
import { buildZip } from "./export.js";

// ---------- worker pool ----------
class Pool {
  constructor(n, files) {
    this.queue = []; this.idle = []; this.jobs = new Map(); this.seq = 0;
    this.ready = Promise.all(Array.from({ length: n }, () => new Promise((res) => {
      const w = new Worker("./worker.js", { type: "module" });
      w.onmessage = (ev) => { if (ev.data.type === "ready") { this.idle.push(w); res(); this.pump(); } else if (ev.data.type === "done") { const j = this.jobs.get(ev.data.id); this.jobs.delete(ev.data.id); this.idle.push(w); j?.resolve(ev.data); this.pump(); } };
      w.onerror = (e) => { console.error(e); res(); };
      w.postMessage({ type: "init", files });
    })));
  }
  run(args, ext, binary = false) { return new Promise((resolve) => { this.queue.push({ id: ++this.seq, args, ext, binary, resolve }); this.pump(); }); }
  pump() { while (this.idle.length && this.queue.length) { const w = this.idle.pop(); const j = this.queue.shift(); this.jobs.set(j.id, j); w.postMessage({ type: "run", id: j.id, args: j.args, ext: j.ext, binary: j.binary }); } }
}

// ---------- state ----------
const SIMPLE = ["cabinet_style", "design_preset", "screen_orientation", "players", "buttons_per_player", "button_layout", "trackball_enabled",
  "material_thickness", "plexi_thickness", "tool_diameter", "panel_joinery", "panel_inset", "marquee_mode", "standup_control_height", "bartop_control_height",
  "cabinet_width", "cabinet_depth", "cabinet_height"];
const HIDE = new Set(["output_mode", "part_name", "show_plexi_preview", "show_screen_preview", "show_vesa_adjustment_envelope", "show_cutaway", "layout_gap", "layout_row_width"]);
const LABELS = { cabinet_style: "Cabinet style", design_preset: "Start from a preset", screen_orientation: "Screen orientation", players: "Players", buttons_per_player: "Buttons per player", button_layout: "Button layout", trackball_enabled: "Trackball", material_thickness: "Sheet thickness (mm)", plexi_thickness: "Plexi thickness (mm)", tool_diameter: "Router bit diameter (mm)", panel_joinery: "Panel joinery", panel_inset: "Panel inset / T-moulding reveal (mm)", marquee_mode: "Marquee", standup_control_height: "Control height, stand-up (mm)", bartop_control_height: "Control height, bartop (mm)", cabinet_width: "Cabinet width (mm, 0 = auto)", cabinet_depth: "Cabinet depth (mm, 0 = auto)", cabinet_height: "Cabinet height (mm, 0 = auto)" };

const state = { params: [], byName: {}, overrides: {}, pool: null, viewer: null, parts: {}, bom: [], info: null, sceneItems: [], busy: false, dirty: false, timer: null };
const $ = (s) => document.querySelector(s);

function val(name) { return name in state.overrides ? state.overrides[name] : state.byName[name]?.default; }
function set(name, value) {
  const def = state.byName[name]; if (!def) return;
  if (def.type === "number") value = Number(value); if (def.type === "bool") value = !!value;
  if (value === def.default || value === "" || (def.type === "number" && !Number.isFinite(value))) delete state.overrides[name]; else state.overrides[name] = value;
  syncInputs(name); saveHash(); scheduleRender();
}
function dArgs() { const out = []; for (const [k, v] of Object.entries(state.overrides)) { const def = state.byName[k]; if (def) out.push("-D", `${k}=${scadLiteral(def, v)}`); } return out; }

// ---------- URL sharing ----------
function saveHash() { try { const s = Object.keys(state.overrides).length ? btoa(unescape(encodeURIComponent(JSON.stringify(state.overrides)))).replace(/=+$/, "") : ""; history.replaceState(null, "", s ? "#" + s : location.pathname); } catch {} }
function loadHash() { try { const h = location.hash.slice(1); if (!h) return; const o = JSON.parse(decodeURIComponent(escape(atob(h)))); for (const [k, v] of Object.entries(o)) if (state.byName[k]) state.overrides[k] = v; } catch {} }

// ---------- form ----------
function label(def) { return LABELS[def.name] || def.name.replace(/_/g, " ").replace(/^\w/, (c) => c.toUpperCase()); }
function fieldFor(def) {
  const wrap = document.createElement("label"); wrap.className = "field"; wrap.dataset.param = def.name;
  const title = document.createElement("span"); title.className = "field-label"; title.textContent = label(def); wrap.appendChild(title);
  let input;
  if (def.type === "bool") { input = document.createElement("input"); input.type = "checkbox"; input.checked = !!val(def.name); input.addEventListener("change", () => set(def.name, input.checked)); wrap.classList.add("field-bool"); }
  else if (def.options) { input = document.createElement("select"); for (const o of def.options) { const opt = document.createElement("option"); opt.value = o; opt.textContent = o; input.appendChild(opt); } input.value = val(def.name); input.addEventListener("change", () => set(def.name, def.type === "number" ? Number(input.value) : input.value)); }
  else { input = document.createElement("input"); input.type = def.type === "number" ? "number" : "text"; if (def.range) { input.min = def.range.min; input.max = def.range.max; if (def.range.step) input.step = def.range.step; } else if (def.type === "number") input.step = "any"; input.value = val(def.name); input.addEventListener("change", () => set(def.name, input.value)); }
  input.name = def.name; wrap.appendChild(input);
  if (def.desc) { const d = document.createElement("small"); d.textContent = def.desc; wrap.appendChild(d); }
  return wrap;
}
function syncInputs(name) { for (const el of document.querySelectorAll(`[name="${name}"]`)) { if (el.type === "checkbox") el.checked = !!val(name); else el.value = val(name); } for (const el of document.querySelectorAll(`[data-param="${name}"]`)) el.classList.toggle("changed", name in state.overrides); updateStyleVisibility(); updateMonitorHints(); }
function updateStyleVisibility() {
  const style = val("cabinet_style"); const isVpin = style.startsWith("vpin"); const isStandup = style === "standup"; const isBartop = style === "bartop";
  for (const el of document.querySelectorAll("[data-param]")) {
    const n = el.dataset.param; let show = true;
    if (n.startsWith("vpin_") || n.startsWith("backglass_") || n.startsWith("pinball_")) show = isVpin;
    else if (n.startsWith("standup_")) show = isStandup;
    else if (n.startsWith("bartop_")) show = isBartop;
    else if (/^(marquee|keyboard_drawer|coin_door|kick_drop|control_fascia|speaker|button|joystick|players|aux_|admin_|trackball|control_panel|controls_|player_spacing|upper_bezel|standup_)/.test(n)) show = !isVpin;
    el.classList.toggle("hidden", !show);
  }
  for (const sec of document.querySelectorAll("details.group")) sec.classList.toggle("hidden", ![...sec.querySelectorAll("[data-param]")].some((e) => !e.classList.contains("hidden")));
}

function buildForm() {
  const simple = $("#simple-fields"); const adv = $("#advanced-groups");
  for (const n of SIMPLE) { const def = state.byName[n]; if (def) simple.appendChild(fieldFor(def)); }
  const groups = new Map();
  for (const def of state.params) { if (HIDE.has(def.name) || SIMPLE.includes(def.name)) continue; if (!groups.has(def.group)) groups.set(def.group, []); groups.get(def.group).push(def); }
  for (const [g, defs] of groups) { if (g === "Output") continue; const d = document.createElement("details"); d.className = "group"; const s = document.createElement("summary"); s.textContent = g; d.appendChild(s); for (const def of defs) d.appendChild(fieldFor(def)); adv.appendChild(d); }
  buildMonitorPicker();
  for (const n of Object.keys(state.byName)) syncInputs(n);
}

// ---------- monitor pickers ----------
// Two pickers share this code: the main / playfield screen and, for pinball
// styles, the backglass monitor. Each picker is a .monitor-picker element whose
// data-w / data-h name the generator parameters it edits.
const isVpinStyle = () => String(val("cabinet_style")).startsWith("vpin");
function playfieldNeed(w, h) {
  const orient = val("screen_orientation");
  const portrait = orient === "portrait" || (orient === "auto" && isVpinStyle());
  const across = portrait ? Math.min(w, h) : Math.max(w, h);
  const margin = isVpinStyle() ? val("vpin_side_screen_margin") : val("screen_side_margin");
  return Math.round(across + 2 * margin + 2 * val("material_thickness"));
}
function backglassNeed(w, h) {
  return Math.round(Math.max(w, h) + 2 * val("screen_cutout_clearance") + 2 * val("backglass_side_margin") + 2 * val("material_thickness"));
}
const pickers = () => [...document.querySelectorAll(".monitor-picker")];
const needFor = (pk) => (pk.dataset.kind === "backglass" ? backglassNeed : playfieldNeed);
function buildMonitorPicker() {
  for (const pk of pickers()) {
    const sel = pk.querySelector(".monitor-select"), wIn = pk.querySelector(".mon-w"), hIn = pk.querySelector(".mon-h");
    const W = pk.dataset.w, H = pk.dataset.h;
    const custom = document.createElement("option"); custom.value = "custom"; custom.textContent = "Custom active area"; sel.appendChild(custom);
    MONITORS.forEach((m, i) => { const o = document.createElement("option"); o.value = i; o.textContent = m.label; sel.appendChild(o); });
    sel.addEventListener("change", () => { if (sel.value === "custom") return; const m = MONITORS[sel.value]; const a = activeArea(m.d, m.aspect); set(W, a.w); set(H, a.h); });
    wIn.addEventListener("change", () => set(W, wIn.value));
    hIn.addEventListener("change", () => set(H, hIn.value));
  }
  $("#fit-width").addEventListener("input", updateMonitorHints);
  updateMonitorHints();
}
function updateMonitorHints() {
  if (!pickers().length || !state.byName.cabinet_style) return;
  const vpin = isVpinStyle() && val("vpin_backbox_enabled");
  $("#backglass-card").classList.toggle("hidden", !vpin);
  $("#main-screen-title").textContent = isVpinStyle() ? "Playfield monitor" : "Screen";
  const limit = Number($("#fit-width").value) || 0;
  const needs = [];
  for (const pk of pickers()) {
    if (pk.dataset.kind === "backglass" && !vpin) continue;
    const sel = pk.querySelector(".monitor-select"); const W = pk.dataset.w, H = pk.dataset.h;
    const sw = Number(val(W)), sh = Number(val(H)); const need = needFor(pk);
    pk.querySelector(".mon-w").value = sw; pk.querySelector(".mon-h").value = sh;
    let matched = false;
    for (const o of sel.options) {
      if (o.value === "custom") continue;
      const m = MONITORS[o.value]; const a = activeArea(m.d, m.aspect); const n = need(a.w, a.h); const fits = !limit || n <= limit;
      o.textContent = `${m.label}  ·  ${a.w}×${a.h} mm  ·  cabinet ≥ ${n} mm${limit ? (fits ? " ✓" : " ✗") : ""}`;
      o.disabled = !!limit && !fits;
      if (a.w === sw && a.h === sh) { sel.value = o.value; matched = true; }
    }
    if (!matched) sel.value = "custom";
    const n = need(sw, sh); needs.push(n);
    pk.querySelector(".mon-need").textContent = `Needs a cabinet at least ${n} mm wide.`;
  }
  const minimum = isVpinStyle() ? 700 : (Number(val("players")) === 2 ? 700 : 560);
  const auto = Math.max(minimum, ...needs); const forced = Number(val("cabinet_width")) || 0;
  $("#width-summary").textContent = forced
    ? `Cabinet width is set to ${forced} mm${forced < Math.max(...needs) ? `, but the monitors need ${Math.max(...needs)} mm` : ""}.`
    : `Automatic cabinet width: ${auto} mm${needs.length > 1 ? ` (the wider of the two monitors decides, minimum ${minimum} mm)` : ""}.`;
}

// ---------- rendering pipeline ----------
function scheduleRender() { clearTimeout(state.timer); state.timer = setTimeout(render, 350); }
function parseEcho(text) {
  const out = { info: null, bom: [], layout: [], scene: [], errors: [], warnings: [] };
  for (const raw of text.split(/\r?\n/)) {
    let line = raw.trim(); if (!line) continue;
    if (line.startsWith("ECHO: ")) { line = line.slice(6); if (line.startsWith('"') && line.endsWith('"')) line = line.slice(1, -1); }
    const i = line.indexOf(":"); const tag = line.slice(0, i);
    if (["INFO", "BOM", "LAYOUT", "SCENE"].includes(tag)) { try { const obj = JSON.parse(line.slice(i + 1)); if (tag === "INFO") out.info = obj; else out[tag.toLowerCase()].push(obj); } catch (e) { out.warnings.push("Unparsed: " + line); } }
    else if (line.startsWith("ERROR:")) { const m = line.match(/failed: "(.*?)" in file/); out.errors.push(m ? m[1] : line.replace(/^ERROR:\s*/, "")); }
    else if (line.startsWith("WARNING:")) out.warnings.push(line.replace(/^WARNING:\s*/, "").replace(/ in file.*$/, ""));
  }
  return out;
}
async function render() {
  if (state.busy) { state.dirty = true; return; }
  state.busy = true; state.dirty = false;
  setStatus("Rendering…", true);
  const args = dArgs();
  const t0 = performance.now();
  try {
    const [echo, sheet] = await Promise.all([state.pool.run([...args, "-D", 'output_mode="scene"'], "echo"), state.pool.run([...args, "-D", 'output_mode="all_sheet"'], "svg")]);
    const parsed = parseEcho((echo.output || "") + "\n" + echo.log.join("\n"));
    const sheetLog = parseEcho(sheet.log.join("\n"));
    const errors = [...new Set([...parsed.errors, ...sheetLog.errors])]; const warnings = [...new Set([...parsed.warnings, ...sheetLog.warnings])].filter((w) => !/localization|Could not initialize/.test(w));
    showMessages(errors, warnings);
    if (parsed.info && sheet.ok) {
      const polys = parseSvgPaths(sheet.output);
      state.parts = splitByLayout(polys, parsed.layout);
      state.bom = parsed.bom; state.info = parsed.info; state.sceneItems = parsed.scene; state.sheetSvg = sheet.output;
      state.viewer.build(parsed.scene, state.parts, parsed.info);
      renderSummary(); renderParts(); renderSheet(); renderBom();
      $("#download").disabled = false;
    } else if (!errors.length) errors.push("The generator produced no output. Check the browser console.");
    setStatus(errors.length ? "Fix the configuration to continue" : `Ready · ${Math.round(performance.now() - t0)} ms`, false);
  } catch (e) { console.error(e); setStatus("Render failed: " + e.message, false); }
  state.busy = false;
  if (state.dirty) render();
}
function setStatus(text, busy) { $("#status").textContent = text; $("#status").classList.toggle("busy", busy); }
function showMessages(errors, warnings) {
  const box = $("#messages"); box.innerHTML = "";
  for (const e of errors) { const d = document.createElement("div"); d.className = "msg error"; d.textContent = e; box.appendChild(d); }
  for (const w of warnings) { const d = document.createElement("div"); d.className = "msg warn"; d.textContent = w; box.appendChild(d); }
  box.classList.toggle("hidden", !errors.length && !warnings.length);
}
const mm = (v) => `${Math.round(v)} mm`; const inch = (v) => `${(v / 25.4).toFixed(1)}″`;
function renderSummary() {
  const i = state.info;
  const wood = state.bom.filter((b) => b.material === "wood").reduce((a, b) => a + b.w * b.len * b.qty, 0) / 1e6;
  $("#summary").innerHTML = `
    <div><b>Overall</b> ${mm(i.W)} × ${mm(i.D)} × ${mm(i.H)} <small>(${inch(i.W)} × ${inch(i.D)} × ${inch(i.H)}, W × D × H)</small></div>
    <div><b>${i.backglass_w ? "Playfield" : "Screen"}</b> ${i.screen_w} × ${i.screen_h} mm${i.backglass_w ? ` · <b>Backglass</b> ${i.backglass_w} × ${i.backglass_h} mm · <b>Backbox</b> ${mm(i.backbox_h)} tall` : ""} · <b>Inner width</b> ${mm(i.IW)}${i.style.startsWith("vpin") ? "" : ` · <b>Control height</b> ${mm(i.control_height)}`}</div>
    <div><b>Parts</b> ${state.bom.reduce((a, b) => a + b.qty, 0)} · <b>Wood</b> ${wood.toFixed(2)} m² (${Math.ceil(wood / (2.44 * 1.22 * 0.7))} sheets of 2440×1220 at 70 % yield)</div>`;
}
function renderParts() {
  const g = $("#parts-grid"); g.innerHTML = "";
  for (const b of state.bom) {
    const p = state.parts[b.part]; if (!p) continue;
    const card = document.createElement("div"); card.className = "part-card";
    card.innerHTML = `<div class="part-svg">${partSvg(p.polys, p.w, p.h, { fill: b.material === "plexi" ? "#7fb8e6" : b.material === "pockets" ? "#c97b5a" : "#3b5b8a" }).replace(/^[\s\S]*?<svg/, "<svg")}</div><div class="part-name">${b.part}${b.qty > 1 ? ` ×${b.qty}` : ""}</div><div class="part-dim">${b.material} · ${b.w} × ${b.len} mm</div>`;
    g.appendChild(card);
  }
}
function renderSheet() { $("#sheet-view").innerHTML = state.sheetSvg.replace(/^[\s\S]*?<svg/, "<svg").replace(/<path /, '<path fill="#3b5b8a" fill-rule="evenodd" '); }
function renderBom() {
  const t = $("#bom-table tbody"); t.innerHTML = "";
  for (const b of state.bom) { const tr = document.createElement("tr"); tr.innerHTML = `<td>${b.part}</td><td>${b.material}</td><td class="num">${b.w}</td><td class="num">${b.len}</td><td class="num">${b.qty}</td>`; t.appendChild(tr); }
}

// ---------- download / share ----------
async function download() {
  const btn = $("#download"); btn.disabled = true;
  try {
    const blob = await buildZip({ pool: state.pool, dArgs: dArgs(), parts: state.parts, bom: state.bom, info: state.info, overrides: state.overrides, onProgress: (d, t) => setStatus(`Exporting ${d}/${t}…`, true) });
    const a = document.createElement("a"); a.href = URL.createObjectURL(blob); const i = state.info; a.download = `cabinet_${i.style}_${Math.round(i.W)}x${Math.round(i.D)}x${Math.round(i.H)}.zip`; a.click(); setTimeout(() => URL.revokeObjectURL(a.href), 10000);
    setStatus("Export ready", false);
  } catch (e) { console.error(e); setStatus("Export failed: " + e.message, false); }
  btn.disabled = false;
}
async function copyLink() { saveHash(); try { await navigator.clipboard.writeText(location.href); setStatus("Link copied", false); } catch { prompt("Copy this link", location.href); } }
function reset() { state.overrides = {}; for (const n of Object.keys(state.byName)) syncInputs(n); saveHash(); scheduleRender(); }

// ---------- tabs ----------
function initTabs() { for (const b of document.querySelectorAll(".tab")) b.addEventListener("click", () => { for (const x of document.querySelectorAll(".tab")) x.classList.toggle("active", x === b); for (const p of document.querySelectorAll(".pane")) p.classList.toggle("active", p.id === b.dataset.pane); if (b.dataset.pane === "pane-3d") state.viewer.resize(); }); }

// ---------- boot ----------
async function boot() {
  setStatus("Loading generator…", true);
  const manifest = await (await fetch("./scad/manifest.json")).json();
  const files = {};
  await Promise.all(manifest.map(async (f) => { files[f] = await (await fetch("./scad/" + f)).text(); }));
  state.params = parseParams(files["arcade_cabinet_workshop.scad"]);
  for (const p of state.params) state.byName[p.name] = p;
  loadHash();
  buildForm();
  initTabs();
  state.viewer = new Viewer($("#viewer"));
  $("#cutaway").addEventListener("change", (e) => state.viewer.setCutaway(e.target.checked, state.info?.W || 700));
  $("#download").addEventListener("click", download);
  $("#share").addEventListener("click", copyLink);
  $("#reset").addEventListener("click", reset);
  setStatus("Starting OpenSCAD…", true);
  state.pool = new Pool(Math.min(3, Math.max(2, (navigator.hardwareConcurrency || 4) - 1)), files);
  await state.pool.ready;
  render();
}
boot().catch((e) => { console.error(e); setStatus("Failed to start: " + e.message, false); });
