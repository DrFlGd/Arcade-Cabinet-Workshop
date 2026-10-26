// Three.js viewer: extrudes each 2D part outline by its thickness and places
// it with the matrix from the generator's "scene" output.
import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls.js";
import { nestPolys } from "./outlines.js";

const COLORS = { side: 0x4b4b50, panel: 0xc9a46b, inner: 0xa98753, plexi: 0x8ec8ff, door: 0x6f6a63, screen: 0x0a0a0c, leg: 0x3a3a3a };

export class Viewer {
  constructor(container) {
    this.container = container;
    this.renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
    this.renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    this.renderer.localClippingEnabled = true;
    container.appendChild(this.renderer.domElement);
    this.scene = new THREE.Scene();
    this.camera = new THREE.PerspectiveCamera(40, 1, 10, 50000);
    this.controls = new OrbitControls(this.camera, this.renderer.domElement);
    this.controls.enableDamping = true;
    this.root = new THREE.Group();
    this.root.rotation.x = -Math.PI / 2;            // OpenSCAD z-up -> three y-up
    this.scene.add(this.root);
    const hemi = new THREE.HemisphereLight(0xffffff, 0x667788, 1.1); this.scene.add(hemi);
    const key = new THREE.DirectionalLight(0xffffff, 1.4); key.position.set(-1500, 2500, 2000); this.scene.add(key);
    const fill = new THREE.DirectionalLight(0xffffff, 0.5); fill.position.set(2000, 1000, -1500); this.scene.add(fill);
    this.clip = new THREE.Plane(new THREE.Vector3(1, 0, 0), 0);   // in root space after transform; set per frame
    this.cutaway = false;
    this.fitted = false;
    this.materials = {};
    for (const [k, c] of Object.entries(COLORS)) {
      this.materials[k] = new THREE.MeshStandardMaterial({ color: c, roughness: 0.75, metalness: 0.05, side: THREE.DoubleSide, transparent: k === "plexi", opacity: k === "plexi" ? 0.35 : 1, clippingPlanes: [] });
      if (k === "screen") { this.materials[k].roughness = 0.3; }
      if (k === "plexi") {
        // Plexi lies flat on its panel, so their faces are coplanar. Pull it toward the
        // camera in depth and do not write depth, otherwise the two fight and flicker.
        Object.assign(this.materials[k], { depthWrite: false, polygonOffset: true, polygonOffsetFactor: -4, polygonOffsetUnits: -4, roughness: 0.1, metalness: 0 });
      }
    }
    this.floor = new THREE.GridHelper(4000, 40, 0x999999, 0xdddddd);
    this.floor.material.depthWrite = false;   // grid lines never fight the cabinet's bottom faces
    this.scene.add(this.floor);
    window.addEventListener("resize", () => this.resize());
    this.resize();
    const loop = () => { this.controls.update(); this.renderer.render(this.scene, this.camera); requestAnimationFrame(loop); };
    loop();
  }
  resize() {
    const w = this.container.clientWidth || 600, h = this.container.clientHeight || 400;
    this.renderer.setSize(w, h, false);
    this.camera.aspect = w / h; this.camera.updateProjectionMatrix();
  }
  setCutaway(on, width) {
    this.cutaway = on;
    const planes = on ? [new THREE.Plane(new THREE.Vector3(-1, 0, 0), width / 2)] : [];   // keep x <= W/2 (world x == scad x)
    for (const m of Object.values(this.materials)) { m.clippingPlanes = planes; m.needsUpdate = true; }
  }
  build(sceneItems, parts, info) {
    while (this.root.children.length) { const c = this.root.children.pop(); c.geometry?.dispose(); }
    const shapesCache = {};
    for (const item of sceneItems) {
      let geom;
      if (item.box) geom = new THREE.BoxGeometry(item.box[0], item.box[1], item.box[2]).translate(item.box[0] / 2, item.box[1] / 2, item.box[2] / 2);
      else {
        const part = parts[item.part]; if (!part || !part.polys.length) continue;
        if (!shapesCache[item.part]) {
          shapesCache[item.part] = nestPolys(part.polys).map((s) => { const sh = new THREE.Shape(s.outer.map(([x, y]) => new THREE.Vector2(x, y))); for (const h of s.holes) sh.holes.push(new THREE.Path(h.map(([x, y]) => new THREE.Vector2(x, y)))); return sh; });
        }
        geom = new THREE.ExtrudeGeometry(shapesCache[item.part], { depth: item.t, bevelEnabled: false, curveSegments: 4 });
      }
      const mesh = new THREE.Mesh(geom, this.materials[item.kind] || this.materials.panel);
      if (item.kind === "plexi") mesh.renderOrder = 10;   // after every opaque part
      mesh.matrixAutoUpdate = false;
      const m = item.m; mesh.matrix.set(m[0][0], m[0][1], m[0][2], m[0][3], m[1][0], m[1][1], m[1][2], m[1][3], m[2][0], m[2][1], m[2][2], m[2][3], 0, 0, 0, 1);
      this.root.add(mesh);
    }
    this.floor.position.y = -1;
    this.setCutaway(this.cutaway, info.W);
    const sizeKey = `${Math.round(info.W)}x${Math.round(info.D)}x${Math.round(info.H)}`;
    if (!this.fitted || this.sizeKey !== sizeKey) { this.fit(info); this.sizeKey = sizeKey; this.fitted = true; }
  }
  fit(info) {
    const cx = info.W / 2, cz = -info.D / 2, cy = info.H / 2;    // root rotated: scad y -> -z
    const r = Math.hypot(info.W, info.D, info.H) / 2;
    this.controls.target.set(cx, cy, cz);
    this.camera.position.set(cx - r * 1.6, cy + r * 0.9, cz + r * 1.9);
    this.camera.near = r / 50; this.camera.far = r * 40; this.camera.updateProjectionMatrix();
    this.controls.update();
  }
}
