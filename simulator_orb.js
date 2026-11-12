/**
 * HERMES SUPER AI — SPATIAL VOICE ORB & AUDIO VISUALIZER (simulator_orb.js)
 * 60 FPS Canvas 2D/3D-Projected Fluid Glass Orb + Mirror Spectrum + Web Audio VAD
 */
(function (global) {
  'use strict';

  class SpatialVoiceOrb {
    constructor(canvasEl, options = {}) {
      this.canvas = canvasEl;
      this.ctx = canvasEl ? canvasEl.getContext('2d') : null;
      this.state = 'idle'; // 'idle' | 'listening' | 'thinking' | 'speaking'
      this.theme = options.theme || 'dark';
      this.amplitude = 0.08;
      this.targetAmplitude = 0.08;
      this.time = 0;
      this.rafId = null;
      this.particles = this._initParticles(44);
      this.bars = new Array(24).fill(0.12);

      // Web Audio API VAD state
      this.audioCtx = null;
      this.analyser = null;
      this.micStream = null;
      this.micActive = false;
      this.isMuted = false;
      this.lastSpeechAt = 0;
      this.hasSpokenInTurn = false;
      this.vadThreshold = options.vadThreshold || 0.045;
      this.vadSilenceMs = options.vadSilenceMs || 750;

      this.onSilenceDetected = options.onSilenceDetected || null;
      this.onBargeInDetected = options.onBargeInDetected || null;
      this.onAmplitude = options.onAmplitude || null;
    }

    _initParticles(count) {
      const list = [];
      for (let i = 0; i < count; i++) {
        list.push({
          theta: Math.random() * Math.PI * 2,
          phi: Math.acos(2 * Math.random() - 1),
          speed: 0.004 + Math.random() * 0.009,
          radiusOffset: 0.85 + Math.random() * 0.35,
          size: 1.1 + Math.random() * 2.0,
          huePick: i % 3
        });
      }
      return list;
    }

    setState(nextState) {
      this.state = nextState;
      if (nextState === 'listening') {
        this.hasSpokenInTurn = false;
        this.lastSpeechAt = performance.now();
      }
    }

    setTheme(theme) {
      this.theme = theme;
    }

    setMuted(muted) {
      this.isMuted = Boolean(muted);
      if (this.micStream) {
        this.micStream.getAudioTracks().forEach((t) => {
          t.enabled = !this.isMuted;
        });
      }
    }

    setSimulatedAmplitude(val) {
      this.targetAmplitude = Math.max(0.05, Math.min(1.0, Number(val) || 0.08));
    }

    resize() {
      if (!this.canvas) return;
      const rect = this.canvas.getBoundingClientRect();
      const dpr = Math.min(global.devicePixelRatio || 1, 2);
      const width = Math.max(220, Math.round(rect.width || 240));
      const height = Math.max(220, Math.round(rect.height || 240));
      this.canvas.width = width * dpr;
      this.canvas.height = height * dpr;
    }

    async startMicrophone() {
      if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        return { ok: false, reason: 'Web Audio API / Microphone tidak didukung di browser ini.' };
      }
      try {
        this.micStream = await navigator.mediaDevices.getUserMedia({
          audio: { echoCancellation: true, noiseSuppression: true, autoGainControl: true }
        });
        const AudioCtx = global.AudioContext || global.webkitAudioContext;
        this.audioCtx = new AudioCtx();
        const source = this.audioCtx.createMediaStreamSource(this.micStream);
        this.analyser = this.audioCtx.createAnalyser();
        this.analyser.fftSize = 256;
        source.connect(this.analyser);
        this.micActive = true;
        this.isMuted = false;
        return { ok: true };
      } catch (err) {
        this.micActive = false;
        return { ok: false, reason: err.message || 'Izin mikrofon ditolak.' };
      }
    }

    stopMicrophone() {
      this.micActive = false;
      if (this.micStream) {
        this.micStream.getTracks().forEach((t) => t.stop());
        this.micStream = null;
      }
      if (this.audioCtx && this.audioCtx.state !== 'closed') {
        this.audioCtx.close().catch(() => {});
        this.audioCtx = null;
      }
      this.analyser = null;
    }

    start() {
      if (this.rafId) return;
      const tick = (now) => {
        this._update(now);
        this._draw();
        this.rafId = requestAnimationFrame(tick);
      };
      this.rafId = requestAnimationFrame(tick);
    }

    stop() {
      if (this.rafId) {
        cancelAnimationFrame(this.rafId);
        this.rafId = null;
      }
      this.stopMicrophone();
    }

    _update(now) {
      this.time += 0.025;

      // Read real microphone RMS if active and unmuted
      if (this.micActive && this.analyser && !this.isMuted) {
        const data = new Uint8Array(this.analyser.frequencyBinCount);
        this.analyser.getByteTimeDomainData(data);
        let sumSq = 0;
        for (let i = 0; i < data.length; i++) {
          const norm = (data[i] - 128) / 128;
          sumSq += norm * norm;
        }
        const rms = Math.sqrt(sumSq / data.length);
        const scaled = Math.min(1.0, rms * 4.5);

        if (this.state === 'listening') {
          this.targetAmplitude = Math.max(0.1, scaled);
          if (rms > this.vadThreshold) {
            this.hasSpokenInTurn = true;
            this.lastSpeechAt = now;
          } else if (this.hasSpokenInTurn && now - this.lastSpeechAt >= this.vadSilenceMs) {
            this.hasSpokenInTurn = false;
            if (typeof this.onSilenceDetected === 'function') {
              this.onSilenceDetected();
            }
          }
        } else if (this.state === 'speaking' && rms > this.vadThreshold * 1.9) {
          if (typeof this.onBargeInDetected === 'function') {
            this.onBargeInDetected();
          }
        }
      } else {
        // Synthetic expressive wave per state
        if (this.state === 'idle') {
          this.targetAmplitude = 0.08 + Math.sin(this.time * 1.1) * 0.03;
        } else if (this.state === 'listening') {
          this.targetAmplitude = 0.24 + Math.abs(Math.sin(this.time * 2.4)) * 0.22;
        } else if (this.state === 'thinking') {
          this.targetAmplitude = 0.36 + Math.sin(this.time * 4.0) * 0.14;
        } else if (this.state === 'speaking') {
          const voiceMod = Math.abs(Math.sin(this.time * 5.2) * Math.cos(this.time * 2.7));
          this.targetAmplitude = 0.28 + voiceMod * 0.58;
        }
      }

      this.amplitude += (this.targetAmplitude - this.amplitude) * 0.16;

      // Update 24 symmetric waveform bars
      const half = 12;
      for (let i = 0; i < half; i++) {
        const distFromCenter = 1 - i / half;
        const harmonic = Math.abs(Math.sin(this.time * 3.1 + i * 0.48));
        const val = Math.max(0.08, Math.min(1, (0.12 + this.amplitude * 0.88) * distFromCenter * (0.45 + harmonic * 0.7)));
        this.bars[half - 1 - i] = val;
        this.bars[half + i] = val;
      }

      if (typeof this.onAmplitude === 'function') {
        this.onAmplitude(this.amplitude, this.bars);
      }
    }

    _getStatePalette() {
      if (this.state === 'listening') {
        return { primary: '#10B981', secondary: '#38BDF8', glow: 'rgba(16, 185, 129, 0.38)' };
      }
      if (this.state === 'thinking') {
        return { primary: '#A855F7', secondary: '#818CF8', glow: 'rgba(168, 85, 247, 0.42)' };
      }
      if (this.state === 'speaking') {
        return { primary: '#38BDF8', secondary: '#818CF8', glow: 'rgba(56, 189, 248, 0.46)' };
      }
      return { primary: '#94A3B8', secondary: '#38BDF8', glow: 'rgba(56, 189, 248, 0.18)' };
    }

    _draw() {
      if (!this.ctx || !this.canvas) return;
      const ctx = this.ctx;
      const dpr = Math.min(global.devicePixelRatio || 1, 2);
      const rect = this.canvas.getBoundingClientRect();
      const width = Math.max(220, Math.round(rect.width || 240));
      const height = Math.max(220, Math.round(rect.height || 240));

      if (this.canvas.width !== width * dpr || this.canvas.height !== height * dpr) {
        this.canvas.width = width * dpr;
        this.canvas.height = height * dpr;
      }

      ctx.save();
      ctx.scale(dpr, dpr);
      ctx.clearRect(0, 0, width, height);

      const cx = width / 2;
      const cy = height / 2 - 12;
      const baseR = Math.min(width, height) * 0.28;
      const dynamicR = baseR * (1 + this.amplitude * 0.24);
      const pal = this._getStatePalette();

      // 1. Outer Frosted Corona
      const corona = ctx.createRadialGradient(cx, cy, dynamicR * 0.4, cx, cy, dynamicR * 1.95);
      corona.addColorStop(0, pal.glow);
      corona.addColorStop(0.55, 'rgba(129, 140, 248, 0.10)');
      corona.addColorStop(1, 'transparent');
      ctx.fillStyle = corona;
      ctx.beginPath();
      ctx.arc(cx, cy, dynamicR * 1.95, 0, Math.PI * 2);
      ctx.fill();

      // 2. Fluid Organic Deforming Shell (3 layers)
      for (let layer = 0; layer < 3; layer++) {
        ctx.save();
        ctx.beginPath();
        const points = 64;
        for (let i = 0; i <= points; i++) {
          const angle = (i / points) * Math.PI * 2;
          const wave1 = Math.sin(angle * 3 + this.time * (1.8 + layer * 0.5) + layer);
          const wave2 = Math.cos(angle * 5 - this.time * (1.3 + layer * 0.4));
          const offset = (wave1 * 0.6 + wave2 * 0.4) * (4 + this.amplitude * 14);
          const r = dynamicR * (1 - layer * 0.08) + offset;
          const x = cx + Math.cos(angle) * r;
          const y = cy + Math.sin(angle) * r;
          if (i === 0) ctx.moveTo(x, y);
          else ctx.lineTo(x, y);
        }
        ctx.closePath();

        const grad = ctx.createLinearGradient(cx - dynamicR, cy - dynamicR, cx + dynamicR, cy + dynamicR);
        if (layer === 0) {
          grad.addColorStop(0, 'rgba(255, 255, 255, 0.20)');
          grad.addColorStop(0.5, pal.glow);
          grad.addColorStop(1, 'rgba(15, 23, 42, 0.55)');
        } else if (layer === 1) {
          grad.addColorStop(0, pal.primary + 'AA');
          grad.addColorStop(1, pal.secondary + '66');
        } else {
          grad.addColorStop(0, 'rgba(255, 255, 255, 0.85)');
          grad.addColorStop(1, pal.primary + 'CC');
        }
        ctx.fillStyle = grad;
        ctx.fill();

        if (layer === 0) {
          ctx.lineWidth = 1.4;
          ctx.strokeStyle = this.theme === 'light' ? 'rgba(255, 255, 255, 0.85)' : 'rgba(255, 255, 255, 0.36)';
          ctx.stroke();
        }
        ctx.restore();
      }

      // 3. 3D Orbiting Neural Particles
      const rotY = this.time * (this.state === 'thinking' ? 1.4 : 0.65);
      for (const p of this.particles) {
        p.theta += p.speed * (1 + this.amplitude * 1.8);
        const r3d = dynamicR * p.radiusOffset;
        const x3d = r3d * Math.sin(p.phi) * Math.cos(p.theta + rotY);
        const y3d = r3d * Math.cos(p.phi);
        const z3d = r3d * Math.sin(p.phi) * Math.sin(p.theta + rotY);
        const scale = (z3d + r3d * 2) / (r3d * 3);
        const px = cx + x3d;
        const py = cy + y3d;

        ctx.beginPath();
        ctx.arc(px, py, p.size * scale, 0, Math.PI * 2);
        const alpha = Math.max(0.15, Math.min(0.95, scale * 0.85));
        ctx.fillStyle = p.huePick === 0
          ? `rgba(255,255,255,${alpha})`
          : p.huePick === 1
            ? `rgba(56,189,248,${alpha})`
            : `rgba(168,85,247,${alpha})`;
        ctx.fill();
      }

      // 4. Specular Apple VisionOS Glass Reflection Arc
      ctx.save();
      ctx.beginPath();
      ctx.ellipse(cx - dynamicR * 0.28, cy - dynamicR * 0.34, dynamicR * 0.36, dynamicR * 0.16, -0.55, 0, Math.PI * 2);
      const spec = ctx.createLinearGradient(cx - dynamicR * 0.5, cy - dynamicR * 0.5, cx, cy);
      spec.addColorStop(0, 'rgba(255, 255, 255, 0.58)');
      spec.addColorStop(1, 'rgba(255, 255, 255, 0.02)');
      ctx.fillStyle = spec;
      ctx.fill();
      ctx.restore();

      // 5. 24 Mirror Audio Frequency Bars underneath the Orb
      const barCount = this.bars.length;
      const barW = 3.5;
      const gap = 3.5;
      const totalW = barCount * barW + (barCount - 1) * gap;
      const startX = cx - totalW / 2;
      const baseY = height - 18;
      const maxH = 26;

      for (let i = 0; i < barCount; i++) {
        const h = Math.max(4, this.bars[i] * maxH);
        const x = startX + i * (barW + gap);
        const y = baseY - h;
        ctx.fillStyle = i % 2 === 0 ? pal.primary : pal.secondary;
        ctx.beginPath();
        if (ctx.roundRect) {
          ctx.roundRect(x, y, barW, h, 2);
        } else {
          ctx.rect(x, y, barW, h);
        }
        ctx.fill();
      }

      ctx.restore();
    }
  }

  global.SpatialVoiceOrb = SpatialVoiceOrb;
})(window);
