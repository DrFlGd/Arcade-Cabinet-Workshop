// Builds the download bundle: DXF (from OpenSCAD) and SVG for every part,
// sheet overviews, cut list and the configuration needed to reproduce it.
import { partSvg } from "./outlines.js";

export async function buildZip({ pool, dArgs, parts, bom, info, overrides, onProgress }) {
  const zip = new JSZip();
  const names = Object.keys(parts);
  let done = 0; const total = names.length + 2;
  const tick = () => onProgress?.(++done, total);
  const dxfJobs = names.map((name) => pool.run([...dArgs, "-D", 'output_mode="part"', "-D", `part_name="${name}"`], "dxf").then((r) => { if (r.ok) zip.file(`dxf/${name}.dxf`, r.output); tick(); }));
  const sheets = ["wood_sheet", "plexi_sheet"].map((mode) => pool.run([...dArgs, "-D", `output_mode="${mode}"`], "svg").then((r) => { if (r.ok) zip.file(`sheets/${mode}.svg`, r.output); tick(); }));
  for (const name of names) { const p = parts[name]; zip.file(`svg/${name}.svg`, partSvg(p.polys, p.w, p.h, { title: name, fill: p.material === "plexi" ? "#7fb8e6" : "#3b5b8a" })); }
  await Promise.all([...dxfJobs, ...sheets]);
  const csv = ["part,material,width_mm,length_mm,qty", ...bom.map((b) => `${b.part},${b.material},${b.w},${b.len},${b.qty}`)].join("\n") + "\n";
  zip.file("cut_list.csv", csv);
  zip.file("cabinet.json", JSON.stringify({ generated: new Date().toISOString(), overall_mm: { width: info.W, depth: info.D, height: info.H }, parameters: overrides }, null, 2));
  zip.file("openscad_args.txt", dArgs.join(" ") + "\n");
  zip.file("README.txt", readme(info));
  return zip.generateAsync({ type: "blob" });
}

function readme(info) {
  return `Arcade Cabinet Workshop export
==============================
Overall size: ${Math.round(info.W)} x ${Math.round(info.D)} x ${Math.round(info.H)} mm (W x D x H), stock ${info.T} mm, plexi ${info.PT} mm.

dxf/      one DXF per part in millimetres, ready for CAM (apply cutter compensation there)
svg/      the same outlines as SVG
sheets/   row layouts of all wood and plexi parts for a size check (not an optimised nest)
cut_list.csv   part, material, width, length, quantity
cabinet.json   every parameter that differs from the generator defaults
openscad_args.txt   -D flags to reproduce this cabinet with the OpenSCAD command line

Before cutting: measure your monitor's active area and your sheet thickness, and
check joystick / button / trackball hole patterns against the parts you bought.
Hardware templates in the generator are nominal catalogue values.
`;
}
