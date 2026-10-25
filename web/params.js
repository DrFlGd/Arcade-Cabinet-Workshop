// Parses the Customizer-style parameter block of arcade_cabinet_workshop.scad
// into a list of parameter definitions, so the form always matches the
// generator without a hand-maintained schema.
//
//   /* [Group name] */
//   // description for the next parameter
//   name = value; // [a,b,c]  or  // [min:step:max]  or  // [min:max]

export function parseParams(scadText) {
  const params = [];
  let group = "General";
  let pendingDesc = [];
  const lines = scadText.split(/\r?\n/);
  for (const raw of lines) {
    const line = raw.trim();
    if (line.startsWith("include <")) break;              // parameters end where the includes start
    let m = line.match(/^\/\*\s*\[(.+?)\]\s*\*\/$/);
    if (m) { group = m[1].trim(); pendingDesc = []; continue; }
    if (line.startsWith("//")) { pendingDesc.push(line.replace(/^\/\/\s?/, "")); continue; }
    m = line.match(/^([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.+?);\s*(?:\/\/\s*(.*))?$/);
    if (!m) { if (line === "") pendingDesc = []; continue; }
    const [, name, rawValue, trailing] = m;
    const def = { name, group, desc: pendingDesc.join(" "), raw: rawValue };
    pendingDesc = [];
    if (/^".*"$/.test(rawValue)) { def.type = "string"; def.default = rawValue.slice(1, -1); }
    else if (rawValue === "true" || rawValue === "false") { def.type = "bool"; def.default = rawValue === "true"; }
    else if (/^-?\d+(\.\d+)?$/.test(rawValue)) { def.type = "number"; def.default = parseFloat(rawValue); }
    else continue;                                        // vectors or expressions are not editable here
    if (trailing) {
      const o = trailing.match(/\[(.+?)\]/);
      if (o) {
        const body = o[1];
        if (body.includes(":") && def.type === "number") {
          const p = body.split(":").map(Number);
          if (p.length === 3) def.range = { min: p[0], step: p[1], max: p[2] };
          else if (p.length === 2) def.range = { min: p[0], max: p[1] };
        } else {
          def.options = body.split(",").map((s) => s.trim()).filter(Boolean)
            .map((s) => (def.type === "number" ? Number(s) : s));
        }
      }
    }
    if (group === "Hidden") continue;
    params.push(def);
  }
  return params;
}

// Format a JS value as an OpenSCAD -D literal.
export function scadLiteral(def, value) {
  if (def.type === "string") return JSON.stringify(String(value));
  if (def.type === "bool") return value ? "true" : "false";
  const n = Number(value);
  return Number.isFinite(n) ? String(n) : String(def.default);
}
