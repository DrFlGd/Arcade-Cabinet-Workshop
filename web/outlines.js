// Turns the OpenSCAD SVG export of the "all_sheet" layout into per-part
// polygon sets in each part's local coordinates (OpenSCAD 2D space, y up).

// OpenSCAD writes absolute M/L/z paths with y negated.
export function parseSvgPaths(svgText) {
  const polys = [];
  const re = /\bd="([^"]*)"/g;
  let m;
  while ((m = re.exec(svgText))) {
    const toks = m[1].replace(/,/g, " ").split(/\s+/).filter(Boolean);
    let cur = null;
    for (let i = 0; i < toks.length; i++) {
      const t = toks[i];
      if (t === "M" || t === "L") { const x = parseFloat(toks[++i]); const y = -parseFloat(toks[++i]); if (t === "M") { cur = []; polys.push(cur); } cur.push([x, y]); }
      else if (t === "z" || t === "Z") { cur = null; }
      else if (/^-?[\d.]/.test(t)) { const x = parseFloat(t); const y = -parseFloat(toks[++i]); if (!cur) { cur = []; polys.push(cur); } cur.push([x, y]); }
    }
  }
  return polys.filter((p) => p.length >= 3);
}

export function polyArea(p) { let a = 0; for (let i = 0, n = p.length; i < n; i++) { const [x1, y1] = p[i], [x2, y2] = p[(i + 1) % n]; a += x1 * y2 - x2 * y1; } return a / 2; }
export function polyBounds(p) { let x0 = Infinity, y0 = Infinity, x1 = -Infinity, y1 = -Infinity; for (const [x, y] of p) { if (x < x0) x0 = x; if (y < y0) y0 = y; if (x > x1) x1 = x; if (y > y1) y1 = y; } return { x0, y0, x1, y1 }; }
export function pointInPoly(pt, poly) { const [x, y] = pt; let inside = false; for (let i = 0, j = poly.length - 1; i < poly.length; j = i++) { const [xi, yi] = poly[i], [xj, yj] = poly[j]; if (yi > y !== yj > y && x < ((xj - xi) * (y - yi)) / (yj - yi) + xi) inside = !inside; } return inside; }

// Assign every polygon to the layout rect that contains its centre, then
// shift into local coordinates. Returns { partName: { polys, w, h, material } }
// keeping the first instance of each part.
export function splitByLayout(polys, layout) {
  const parts = {};
  const seen = new Set();
  for (const item of layout) { if (!seen.has(item.part)) { seen.add(item.part); parts[item.part] = { polys: [], w: item.w, h: item.h, material: item.material, rect: item }; } }
  for (const poly of polys) {
    const b = polyBounds(poly); const cx = (b.x0 + b.x1) / 2, cy = (b.y0 + b.y1) / 2;
    let best = null, bestDist = Infinity;
    for (const item of layout) {
      const dx = Math.max(item.x - cx, 0, cx - (item.x + item.w)), dy = Math.max(item.y - cy, 0, cy - (item.y + item.h));
      const d = dx * dx + dy * dy; if (d < bestDist) { bestDist = d; best = item; }
    }
    if (!best) continue;
    const slot = parts[best.part];
    if (slot.rect !== best) continue;                 // a later duplicate instance; the first one is enough
    slot.polys.push(poly.map(([x, y]) => [x - best.ox, y - best.oy]));
  }
  return parts;
}

// Nest polygons into outer rings with their holes (even-odd by containment depth).
export function nestPolys(polys) {
  const items = polys.map((p) => ({ p, area: Math.abs(polyArea(p)), depth: 0, parent: null }));
  for (const a of items) {
    for (const b of items) {
      if (a === b || b.area <= a.area) continue;
      if (pointInPoly(a.p[0], b.p)) { a.depth++; if (!a.parent || b.area < a.parent.area) a.parent = b; }
    }
  }
  const shapes = [];
  const byItem = new Map();
  for (const it of items) if (it.depth % 2 === 0) { const s = { outer: it.p, holes: [] }; shapes.push(s); byItem.set(it, s); }
  for (const it of items) if (it.depth % 2 === 1 && it.parent) { const s = byItem.get(it.parent); if (s) s.holes.push(it.p); }
  return shapes;
}

// SVG text for one part in millimetres, same convention as OpenSCAD (y negated).
export function partSvg(polys, w, h, opts = {}) {
  const b = polys.length ? polys.map(polyBounds).reduce((a, c) => ({ x0: Math.min(a.x0, c.x0), y0: Math.min(a.y0, c.y0), x1: Math.max(a.x1, c.x1), y1: Math.max(a.y1, c.y1) })) : { x0: 0, y0: 0, x1: w, y1: h };
  const W = b.x1 - b.x0, H = b.y1 - b.y0;
  const d = polys.map((p) => p.map(([x, y], i) => `${i ? "L" : "M"} ${r(x)},${r(-y)}`).join(" ") + " z").join("\n");
  const fill = opts.fill || "#2f4f7f";
  return `<?xml version="1.0" standalone="no"?>\n<svg width="${r(W)}mm" height="${r(H)}mm" viewBox="${r(b.x0)} ${r(-b.y1)} ${r(W)} ${r(H)}" xmlns="http://www.w3.org/2000/svg" version="1.1">\n<title>${opts.title || "part"}</title>\n<path d="\n${d}\n" fill="${fill}" fill-rule="evenodd" stroke="${opts.stroke || "none"}" stroke-width="0.5"/>\n</svg>\n`;
}
function r(v) { return Math.round(v * 1000) / 1000; }
