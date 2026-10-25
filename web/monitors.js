// Common monitor sizes. Active-area dimensions are derived from the
// diagonal and aspect ratio; real panels differ by a few millimetres, so the
// app tells the builder to measure before cutting.
export const ASPECTS = { "16:9": [16, 9], "16:10": [16, 10], "4:3": [4, 3], "5:4": [5, 4], "21:9": [64, 27] };

export function activeArea(diagonalIn, aspect) {
  const [a, b] = ASPECTS[aspect] || ASPECTS["16:9"];
  const d = diagonalIn * 25.4;
  const k = d / Math.hypot(a, b);
  return { w: Math.round(a * k), h: Math.round(b * k) };
}

export const MONITORS = [
  { label: '10.1" 16:10 (bartop)', d: 10.1, aspect: "16:10" },
  { label: '15.6" 16:9', d: 15.6, aspect: "16:9" },
  { label: '17" 5:4', d: 17, aspect: "5:4" },
  { label: '19" 4:3 (classic)', d: 19, aspect: "4:3" },
  { label: '19" 5:4', d: 19, aspect: "5:4" },
  { label: '20" 4:3', d: 20, aspect: "4:3" },
  { label: '21.5" 16:9', d: 21.5, aspect: "16:9" },
  { label: '24" 16:9', d: 24, aspect: "16:9" },
  { label: '24" 16:10', d: 24, aspect: "16:10" },
  { label: '27" 16:9', d: 27, aspect: "16:9" },
  { label: '32" 16:9', d: 32, aspect: "16:9" },
  { label: '34" 21:9 ultrawide', d: 34, aspect: "21:9" },
  { label: '40" 16:9', d: 40, aspect: "16:9" },
  { label: '43" 16:9', d: 43, aspect: "16:9" },
  { label: '49" 16:9 (pinball playfield)', d: 49, aspect: "16:9" },
  { label: '55" 16:9 (pinball playfield)', d: 55, aspect: "16:9" },
];
