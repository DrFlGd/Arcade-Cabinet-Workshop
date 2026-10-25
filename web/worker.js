// Web worker that runs OpenSCAD (WebAssembly) on the generator sources.
// One fresh instance per run: the Emscripten runtime exits after main().
import { createOpenSCAD } from "./vendor/openscad.js";

let sources = null;   // { path: text }

self.onmessage = async (ev) => {
  const msg = ev.data;
  if (msg.type === "init") { sources = msg.files; self.postMessage({ type: "ready" }); return; }
  if (msg.type !== "run") return;
  const log = [];
  const t0 = performance.now();
  try {
    const scad = await createOpenSCAD({ noInitialRun: true, print: (s) => log.push(s), printErr: (s) => log.push(s) });
    const inst = scad.getInstance();
    const FS = inst.FS;
    FS.mkdir("/p"); FS.mkdir("/p/lib");
    for (const [path, text] of Object.entries(sources)) FS.writeFile("/p/" + path, text);
    const out = "/p/out." + msg.ext;
    const args = ["/p/arcade_cabinet_workshop.scad", ...msg.args, "-o", out];
    if (msg.ext === "echo") args.push("--export-format=echo");
    try { inst.callMain(args); } catch (e) { /* exit() throws through callMain; the output file tells us if it worked */ }
    let output = null;
    try { output = msg.binary ? FS.readFile(out) : FS.readFile(out, { encoding: "utf8" }); } catch (e) { output = null; }
    self.postMessage({ type: "done", id: msg.id, ok: output !== null, output, log, ms: Math.round(performance.now() - t0) }, msg.binary && output ? [output.buffer] : []);
  } catch (e) {
    self.postMessage({ type: "done", id: msg.id, ok: false, output: null, log: [...log, "EXCEPTION: " + String(e)], ms: Math.round(performance.now() - t0) });
  }
};
