/**
 * HERMES SUPER AI — INTERACTIVE MOBILE SIMULATOR ENGINE (simulator_app.js)
 * VisionOS White / Graphite Frost Spatial Edition
 * Implements 5-Screen Commercial Flow, Quick Role Switcher, Chat SSE Streaming,
 * Image Studio, Remotion 60fps Video Lab, Spatial Orb Voice Mode, and Media Vault.
 */

(function () {
  'use strict';

  // --- SEED SHOWCASES (Synchronized with database/seed.js) ---
  const INITIAL_SEED_DATA = {
    roles: {
      superadmin: {
        id: 'usr_admin_001',
        email: 'admin@hermes.ai',
        fullName: 'Lead System Architect',
        roleSlug: 'superadmin',
        roleName: 'Superadmin / System Owner',
        badge: '👑 SUPERADMIN',
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
        quotaTokens: 1000000,
        quotaRenders: 500,
        canSwitchAgents: true,
        canEditSettings: true,
        canDeleteVault: true,
        canExportVault: true,
        videoWatermark: false,
        videoResolution: '1080p 60fps',
        maxDuration: 120
      },
      pro_creator: {
        id: 'usr_pro_002',
        email: 'pro@hermes.ai',
        fullName: 'Elena Rostova (Pro Creator)',
        roleSlug: 'pro_creator',
        roleName: 'Pro Creator',
        badge: '⚡ PRO CREATOR',
        avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
        quotaTokens: 500000,
        quotaRenders: 100,
        canSwitchAgents: true,
        canEditSettings: true,
        canDeleteVault: true,
        canExportVault: true,
        videoWatermark: false,
        videoResolution: '1080p 60fps',
        maxDuration: 60
      },
      consumer: {
        id: 'usr_member_003',
        email: 'member@hermes.ai',
        fullName: 'Kenji Sato (Consumer)',
        roleSlug: 'consumer',
        roleName: 'Consumer / Member',
        badge: '🛍️ CONSUMER',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        quotaTokens: 50000,
        quotaRenders: 10,
        canSwitchAgents: false,
        canEditSettings: false,
        canDeleteVault: true,
        canExportVault: true,
        videoWatermark: true,
        videoResolution: '720p 30fps (Watermarked)',
        maxDuration: 15
      },
      guest: {
        id: 'usr_guest_004',
        email: 'guest@hermes.ai',
        fullName: 'Guest Evaluator',
        roleSlug: 'guest',
        roleName: 'Guest / Demo Evaluator',
        badge: '🧪 GUEST DEMO',
        avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
        quotaTokens: 5000,
        quotaRenders: 2,
        canSwitchAgents: false,
        canEditSettings: false,
        canDeleteVault: false,
        canExportVault: false,
        videoWatermark: true,
        videoResolution: '720p 30fps (Watermarked)',
        maxDuration: 10
      }
    },

    agents: [
      {
        id: 'general',
        name: 'Lead Orchestrator',
        role: 'Multi-Domain Reasoning',
        badge: 'DEFAULT',
        accent: '#38BDF8',
        icon: '⚡',
        description: 'Asisten serbaguna dengan penalaran holistik, penelusuran web cerdas, dan analisis visual.'
      },
      {
        id: 'tech_architect',
        name: 'Fullstack Architect',
        role: 'Systems, API & Mobile CI/CD',
        badge: 'PRO',
        accent: '#818CF8',
        icon: '💻',
        description: 'Spesialis Clean Architecture, streaming SSE berlatensi rendah, SwiftUI/Flutter, dan Remotion.'
      },
      {
        id: 'creative_director',
        name: 'Art & UX Director',
        role: 'VisionOS Spatial & Prompt Craft',
        badge: 'PRO',
        accent: '#C084FC',
        icon: '🎨',
        description: 'Merancang komposisi visual Apple Spatial Glass, naskah narasi video, dan palet Graphite Frost.'
      },
      {
        id: 'business_analyst',
        name: 'Business Analyst',
        role: 'KPI, ROI & Strategy Matrix',
        badge: 'PRO',
        accent: '#10B981',
        icon: '📊',
        description: 'Menghasilkan ringkasan eksekutif terstruktur, tabel KPI, dan pemisahan fakta vs asumsi.'
      }
    ],

    chatMessages: [
      {
        id: 'msg_001',
        role: 'user',
        content: 'Bagaimana arsitektur glassmorphism VisionOS diimplementasikan pada canvas rendering Remotion?',
        timestamp: '10:42 AM',
        webSearch: false
      },
      {
        id: 'msg_002',
        role: 'assistant',
        agent: 'tech_architect',
        content: `Implementasi **VisionOS Glassmorphism** pada Remotion menggabungkan *CSS Backdrop Filters* (\`blur(40px) saturate(180%)\`), *specular border reflection*, dan *SVG shader turbulence* untuk efek refraksi es (**Graphite Frost**).\n\n\`\`\`typescript\n// Remotion Composition Layer\nexport const SpatialGlassLayer = ({ frame, fps }: { frame: number; fps: number }) => {\n  const pulse = Math.sin((frame / fps) * 2) * 8;\n  return (\n    <div className="backdrop-blur-2xl bg-white/10 border border-white/20 rounded-3xl" style={{ boxShadow: \`0 0 \${24 + pulse}px rgba(56,189,248,0.35)\` }}>\n      <NeuralWaveform frame={frame} />\n    </div>\n  );\n};\n\`\`\`\n\nSeluruh layer dirender per-frame pada timeline 60fps dengan sinkronisasi dual-speaker audio.`,
        timestamp: '10:42 AM',
        webSearch: true,
        citations: [
          {
            title: 'Apple VisionOS Spatial Human Interface Guidelines',
            url: 'https://developer.apple.com/design/human-interface-guidelines/visionos',
            domain: 'developer.apple.com',
            snippet: 'Materials, depth, and spatial lighting guidelines for translucent glass surfaces.'
          },
          {
            title: 'Remotion React Video Framework Documentation',
            url: 'https://www.remotion.dev/docs',
            domain: 'remotion.dev',
            snippet: 'Programmatic video creation in React with deterministic frame sequencing.'
          }
        ]
      }
    ],

    imageGallery: [
      {
        id: 'img_gen_001',
        prompt: 'A floating holographic AI sphere encased in graphite frost glass, VisionOS aesthetic, glowing refraction, studio lighting, hyperminimalist',
        ratio: '16:9',
        style: 'VisionOS Spatial Glass',
        resolution: '1280x720',
        seed: 849201,
        url: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=1280&q=80',
        date: 'Hari ini'
      },
      {
        id: 'img_gen_002',
        prompt: 'Minimalist glass card dashboard with neon cyan edge specular borders, floating in spatial fog',
        ratio: '1:1',
        style: 'Ultra Photoreal',
        resolution: '1024x1024',
        seed: 529143,
        url: 'https://images.unsplash.com/photo-1634017839464-5c339ebe3cb4?w=1024&q=80',
        date: 'Hari ini'
      },
      {
        id: 'img_gen_003',
        prompt: 'Futuristic Apple VisionOS spatial cockpit with dynamic holographic telemetry HUD, deep obsidian background',
        ratio: '9:16',
        style: 'Spatial 3D Glass',
        resolution: '720x1280',
        seed: 391824,
        url: 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=1024&q=80',
        date: 'Kemarin'
      }
    ],

    videoStoryboard: [
      {
        beat: 1,
        title: 'Hook Sinematik & Spatial Title',
        time: '0s – 8s',
        speaker: 'Alpha Male (Ardi)',
        script: 'Selamat datang di era baru kecerdasan spasial. Ini adalah Hermes Super AI.',
        bg: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=600&q=70'
      },
      {
        beat: 2,
        title: 'Penjelasan Fitur Terpadu',
        time: '8s – 20s',
        speaker: 'Aria Female (Gadis)',
        script: 'Konsolidasi 5 pilar AI: Chat streaming, Image Studio, Remotion video 60fps, dan Hands-free voice mode.',
        bg: 'https://images.unsplash.com/photo-1634017839464-5c339ebe3cb4?w=600&q=70'
      },
      {
        beat: 3,
        title: 'Call to Action & Sideload Mobile',
        time: '20s – 30s',
        speaker: 'Alpha Male (Ardi)',
        script: 'Jalankan secara mandiri di perangkat iOS via sideload IPA atau nikmati simulator interaktif sekarang.',
        bg: 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=600&q=70'
      }
    ],

    vaultItems: [
      {
        id: 'vlt_001',
        title: 'VisionOS Spatial AI Orb',
        type: 'image',
        thumb: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=400&q=80',
        detail: 'Aspect 16:9 • Seed #849201 • PNG High-Res',
        isFav: true
      },
      {
        id: 'vlt_002',
        title: 'Hermes Launch Teaser Remotion MP4',
        type: 'video',
        thumb: 'https://images.unsplash.com/photo-1634017839464-5c339ebe3cb4?w=400&q=80',
        detail: '1080p 60fps • 30s • Dual-Speaker Ardi & Gadis',
        isFav: true
      },
      {
        id: 'vlt_003',
        title: 'Audio Transkrip Spatial Voice (Tech Architecture)',
        type: 'audio',
        thumb: 'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?w=400&q=80',
        detail: '4m 12s • Hands-free Duplex • VAD 750ms',
        isFav: false
      },
      {
        id: 'vlt_004',
        title: 'VisionOS Spatial Cockpit Concept',
        type: 'image',
        thumb: 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=400&q=80',
        detail: 'Aspect 9:16 • Reels Story Format • PNG',
        isFav: false
      }
    ]
  };

  // --- STATE CONTROLLER ---
  class SimulatorController {
    constructor() {
      this.currentRole = 'pro_creator';
      this.activeTab = 'chat'; // 'chat' | 'studio' | 'video' | 'voice' | 'vault'
      this.activeAgent = 'tech_architect';
      this.theme = 'dark'; // 'dark' (Graphite Frost) | 'light' (VisionOS White)
      this.device = 'iphone'; // 'iphone' | 'android'
      this.webSearchEnabled = true;

      // Video Player Engine state
      this.videoPlaying = false;
      this.videoProgress = 0; // 0..100
      this.videoRaf = null;

      // Voice Orb state
      this.voiceOrb = null;
      this.voiceState = 'idle'; // 'idle' | 'listening' | 'thinking' | 'speaking'
      this.voiceTranscript = 'Selamat datang. Ketuk tombol mic untuk memulai obrolan suara dua arah.';

      // Storage
      this.chatMessages = [...INITIAL_SEED_DATA.chatMessages];
      this.imageGallery = [...INITIAL_SEED_DATA.imageGallery];
      this.vaultItems = [...INITIAL_SEED_DATA.vaultItems];
      this.currentFilter = 'all';

      // Audio Haptic Synthesizer
      this.hapticCtx = null;
    }

    init() {
      this.setupDOM();
      this.setupClock();
      this.setupEventListeners();
      this.setupVoiceOrb();
      this.renderAll();
    }

    // Web Audio Synthesized Tactile Haptic Click
    triggerHaptic(type = 'click') {
      try {
        const AudioContext = window.AudioContext || window.webkitAudioContext;
        if (!this.hapticCtx) {
          this.hapticCtx = new AudioContext();
        }
        if (this.hapticCtx.state === 'suspended') {
          this.hapticCtx.resume();
        }
        const osc = this.hapticCtx.createOscillator();
        const gain = this.hapticCtx.createGain();
        osc.connect(gain);
        gain.connect(this.hapticCtx.destination);

        const now = this.hapticCtx.currentTime;
        if (type === 'tab') {
          osc.frequency.setValueAtTime(440, now);
          osc.frequency.exponentialRampToValueAtTime(880, now + 0.04);
          gain.gain.setValueAtTime(0.04, now);
          gain.gain.exponentialRampToValueAtTime(0.001, now + 0.05);
          osc.start(now);
          osc.stop(now + 0.05);
        } else if (type === 'role') {
          osc.frequency.setValueAtTime(520, now);
          osc.frequency.exponentialRampToValueAtTime(660, now + 0.08);
          gain.gain.setValueAtTime(0.06, now);
          gain.gain.exponentialRampToValueAtTime(0.001, now + 0.09);
          osc.start(now);
          osc.stop(now + 0.09);
        } else {
          osc.frequency.setValueAtTime(320, now);
          osc.frequency.exponentialRampToValueAtTime(140, now + 0.025);
          gain.gain.setValueAtTime(0.03, now);
          gain.gain.exponentialRampToValueAtTime(0.001, now + 0.03);
          osc.start(now);
          osc.stop(now + 0.03);
        }
      } catch (_e) {
        // Fallback gracefully
      }
    }

    setupClock() {
      const update = () => {
        const now = new Date();
        const timeStr = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        const el = document.getElementById('device-clock');
        if (el) el.textContent = timeStr;
      };
      update();
      setInterval(update, 1000);
    }

    setupVoiceOrb() {
      const canvas = document.getElementById('voice-orb-canvas');
      if (!canvas || !window.SpatialVoiceOrb) return;
      this.voiceOrb = new window.SpatialVoiceOrb(canvas, {
        initialState: 'idle',
        theme: this.theme,
        onSilenceDetected: () => {
          this.setVoiceState('thinking');
          setTimeout(() => {
            this.setVoiceState('speaking');
            this.voiceTranscript = 'Saya memahami pertanyaan Anda. Dalam konteks arsitektur spasial, VisionOS memisahkan thread UI 60fps dengan kalkulasi AI streaming berlatensi rendah.';
            this.updateVoiceHUD();
          }, 1200);
        },
        onBargeInDetected: () => {
          this.setVoiceState('listening');
          this.voiceTranscript = 'Mendengarkan interupsi Anda...';
          this.updateVoiceHUD();
        }
      });
      this.voiceOrb.start();
    }

    setVoiceState(state) {
      this.voiceState = state;
      if (this.voiceOrb) {
        this.voiceOrb.setState(state);
      }
      const badge = document.getElementById('voice-status-pill');
      if (badge) {
        const map = {
          idle: { text: '⚪ IDLE / READY', color: 'bg-white/10 text-slate-300 border-white/20' },
          listening: { text: '🟢 LISTENING', color: 'bg-emerald-500/20 text-emerald-400 border-emerald-500/40 animate-pulse' },
          thinking: { text: '🟣 THINKING', color: 'bg-purple-500/20 text-purple-400 border-purple-500/40 animate-pulse' },
          speaking: { text: '🔵 SPEAKING', color: 'bg-sky-500/20 text-sky-400 border-sky-500/40 animate-pulse' }
        };
        const cfg = map[state] || map.idle;
        badge.className = `text-[10px] font-bold tracking-wider px-3 py-1 rounded-full border transition-all ${cfg.color}`;
        badge.textContent = cfg.text;
      }
    }

    updateVoiceHUD() {
      const hud = document.getElementById('voice-live-transcript');
      if (hud) {
        hud.textContent = `"${this.voiceTranscript}"`;
      }
    }

    switchRole(roleSlug) {
      if (!INITIAL_SEED_DATA.roles[roleSlug]) return;
      this.currentRole = roleSlug;
      this.triggerHaptic('role');

      // If user switched to role that doesn't permit agent switching, reset to general
      const policy = INITIAL_SEED_DATA.roles[roleSlug];
      if (!policy.canSwitchAgents) {
        this.activeAgent = 'general';
      }

      this.showToast(`Beralih Peran: ${policy.roleName}`);
      this.renderAll();
    }

    switchTab(tabName) {
      this.activeTab = tabName;
      this.triggerHaptic('tab');

      // Scroll container to top
      const scrollable = document.getElementById('screen-content-viewport');
      if (scrollable) scrollable.scrollTop = 0;

      // If entering voice mode, ensure orb starts and resizes
      if (tabName === 'voice' && this.voiceOrb) {
        setTimeout(() => {
          this.voiceOrb.resize();
          this.setVoiceState('idle');
        }, 80);
      } else if (this.voiceOrb && this.voiceState !== 'idle') {
        this.setVoiceState('idle');
      }

      this.renderTabs();
      this.renderActiveScreen();
    }

    toggleTheme() {
      this.theme = this.theme === 'dark' ? 'light' : 'dark';
      this.triggerHaptic('click');
      const root = document.getElementById('simulator-root');
      if (root) {
        if (this.theme === 'light') {
          root.classList.add('theme-vision-white');
        } else {
          root.classList.remove('theme-vision-white');
        }
      }
      if (this.voiceOrb) {
        this.voiceOrb.setTheme(this.theme);
      }
      this.showToast(`Tema: ${this.theme === 'light' ? 'VisionOS White Alabaster' : 'Graphite Frost Dark'}`);
    }

    toggleDevice() {
      this.device = this.device === 'iphone' ? 'android' : 'iphone';
      this.triggerHaptic('click');
      const frame = document.getElementById('device-chassis');
      const island = document.getElementById('dynamic-island-notch');
      const punchhole = document.getElementById('android-punchhole');
      const homeIndicator = document.getElementById('home-indicator-bar');

      if (this.device === 'iphone') {
        frame.style.borderRadius = '52px';
        island.classList.remove('hidden');
        punchhole.classList.add('hidden');
        homeIndicator.classList.remove('hidden');
        this.showToast('Bingkai: Apple iPhone 15 Pro (VisionOS)');
      } else {
        frame.style.borderRadius = '38px';
        island.classList.add('hidden');
        punchhole.classList.remove('hidden');
        homeIndicator.classList.add('hidden');
        this.showToast('Bingkai: Android Modern Material 3');
      }
    }

    showToast(message) {
      const toast = document.getElementById('simulator-toast');
      if (!toast) return;
      toast.textContent = message;
      toast.classList.remove('opacity-0', 'pointer-events-none', '-translate-y-2');
      toast.classList.add('opacity-100', 'translate-y-0');
      clearTimeout(this.toastTimer);
      this.toastTimer = setTimeout(() => {
        toast.classList.remove('opacity-100', 'translate-y-0');
        toast.classList.add('opacity-0', 'pointer-events-none', '-translate-y-2');
      }, 2200);
    }

    // --- RENDERERS ---
    renderAll() {
      this.renderHeader();
      this.renderTabs();
      this.renderActiveScreen();
    }

    renderHeader() {
      const user = INITIAL_SEED_DATA.roles[this.currentRole];
      const rolePill = document.getElementById('active-role-pill');
      if (rolePill) {
        rolePill.textContent = user.badge;
      }
      const quotaBadge = document.getElementById('header-quota-badge');
      if (quotaBadge) {
        quotaBadge.textContent = `${(user.quotaTokens / 1000).toFixed(0)}k TKN`;
      }
    }

    renderTabs() {
      const tabs = ['chat', 'studio', 'video', 'voice', 'vault'];
      tabs.forEach((t) => {
        const btn = document.getElementById(`tab-btn-${t}`);
        if (!btn) return;
        const icon = btn.querySelector('.tab-icon');
        const label = btn.querySelector('.tab-label');
        if (t === this.activeTab) {
          btn.className = 'tab-nav-btn flex-1 flex flex-col items-center justify-center py-1 transition-all text-sky-400 font-semibold';
          if (icon) icon.classList.add('scale-110', 'text-sky-400');
          if (label) label.classList.add('text-sky-300');
        } else {
          btn.className = 'tab-nav-btn flex-1 flex flex-col items-center justify-center py-1 transition-all text-slate-400 hover:text-slate-200';
          if (icon) icon.classList.remove('scale-110', 'text-sky-400');
          if (label) label.classList.remove('text-sky-300');
        }
      });
    }

    renderActiveScreen() {
      const screens = ['chat', 'studio', 'video', 'voice', 'vault'];
      screens.forEach((s) => {
        const el = document.getElementById(`screen-${s}`);
        if (el) {
          if (s === this.activeTab) {
            el.classList.remove('hidden');
          } else {
            el.classList.add('hidden');
          }
        }
      });

      if (this.activeTab === 'chat') this.renderChatScreen();
      if (this.activeTab === 'studio') this.renderStudioScreen();
      if (this.activeTab === 'video') this.renderVideoScreen();
      if (this.activeTab === 'vault') this.renderVaultScreen();
    }

    // --- SCREEN 1: CHAT MULTIMODAL ---
    renderChatScreen() {
      const policy = INITIAL_SEED_DATA.roles[this.currentRole];
      const agentContainer = document.getElementById('agent-chips-bar');
      if (agentContainer) {
        agentContainer.innerHTML = INITIAL_SEED_DATA.agents.map((ag) => {
          const isActive = ag.id === this.activeAgent;
          const isLocked = !policy.canSwitchAgents && ag.id !== 'general';
          return `
            <button
              onclick="window.simulator.selectAgent('${ag.id}')"
              class="shrink-0 flex items-center space-x-1.5 px-3 py-1.5 rounded-full text-xs transition-all ${
                isActive
                  ? 'bg-sky-500/20 border border-sky-400/60 text-sky-300 shadow-[0_0_12px_rgba(56,189,248,0.35)]'
                  : 'bg-white/5 border border-white/10 text-slate-300 hover:bg-white/10'
              } ${isLocked ? 'opacity-40 cursor-not-allowed' : ''}"
              ${isLocked ? 'disabled' : ''}
            >
              <span>${ag.icon}</span>
              <span class="font-medium">${ag.name}</span>
              ${ag.badge === 'PRO' ? '<span class="text-[9px] px-1 bg-purple-500/30 text-purple-300 rounded font-bold">PRO</span>' : ''}
              ${isLocked ? '<span>🔒</span>' : ''}
            </button>
          `;
        }).join('');
      }

      const streamContainer = document.getElementById('chat-messages-container');
      if (streamContainer) {
        streamContainer.innerHTML = this.chatMessages.map((msg) => {
          const isUser = msg.role === 'user';
          if (isUser) {
            return `
              <div class="flex justify-end mb-3.5">
                <div class="max-w-[85%] bg-slate-800/85 backdrop-blur-md border border-white/15 text-slate-100 px-4 py-2.5 rounded-2xl rounded-tr-sm shadow-md text-sm">
                  ${this.escapeHtml(msg.content)}
                  <div class="text-[10px] text-slate-400 mt-1 text-right">${msg.timestamp}</div>
                </div>
              </div>
            `;
          } else {
            const ag = INITIAL_SEED_DATA.agents.find((a) => a.id === msg.agent) || INITIAL_SEED_DATA.agents[0];
            return `
              <div class="flex justify-start mb-4">
                <div class="flex space-x-2.5 max-w-[94%]">
                  <div class="shrink-0 w-7 h-7 rounded-lg bg-gradient-to-tr from-sky-500 to-indigo-600 flex items-center justify-center text-xs shadow-sm mt-0.5">
                    ${ag.icon}
                  </div>
                  <div class="bg-slate-900/80 backdrop-blur-md border border-white/15 text-slate-200 px-4 py-3 rounded-2xl rounded-tl-sm shadow-lg text-sm">
                    <div class="flex items-center space-x-1.5 mb-1.5">
                      <span class="font-semibold text-xs text-sky-300">${ag.name}</span>
                      <span class="text-[10px] text-slate-400">• ${msg.timestamp}</span>
                    </div>
                    <div class="chat-markdown-body leading-relaxed space-y-2 text-[13.5px]">
                      ${this.formatMarkdown(msg.content)}
                    </div>
                    ${
                      msg.citations && msg.citations.length > 0
                        ? `
                        <div class="mt-3 pt-2.5 border-t border-white/10">
                          <div class="text-[11px] font-semibold text-slate-400 mb-1.5 flex items-center space-x-1">
                            <span>🌐</span><span>Rujukan & Kutipan Grounding:</span>
                          </div>
                          <div class="flex flex-wrap gap-1.5">
                            ${msg.citations.map((c, idx) => `
                              <a href="${c.url}" target="_blank" rel="noopener" class="inline-flex items-center space-x-1 px-2 py-0.5 rounded-md bg-white/5 hover:bg-white/10 border border-white/10 text-[11px] text-sky-400 transition-colors">
                                <span>[${idx + 1}]</span>
                                <span class="truncate max-w-[150px]">${c.domain}</span>
                                <span>↗</span>
                              </a>
                            `).join('')}
                          </div>
                        </div>
                      `
                        : ''
                    }
                  </div>
                </div>
              </div>
            `;
          }
        }).join('');
      }
    }

    selectAgent(agentId) {
      const policy = INITIAL_SEED_DATA.roles[this.currentRole];
      if (!policy.canSwitchAgents && agentId !== 'general') {
        this.showToast('Kunci: Fitur Agen Spesialis memerlukan tier Pro Creator');
        return;
      }
      this.activeAgent = agentId;
      this.triggerHaptic('click');
      const ag = INITIAL_SEED_DATA.agents.find((a) => a.id === agentId);
      this.showToast(`Agen Aktif: ${ag.name}`);
      this.renderChatScreen();
    }

    toggleWebSearch() {
      this.webSearchEnabled = !this.webSearchEnabled;
      this.triggerHaptic('click');
      const btn = document.getElementById('web-search-toggle-btn');
      if (btn) {
        if (this.webSearchEnabled) {
          btn.className = 'px-2.5 py-1 rounded-full text-xs font-semibold bg-sky-500/20 text-sky-400 border border-sky-400/40 flex items-center space-x-1';
          this.showToast('Web Search Grounding: AKTIF');
        } else {
          btn.className = 'px-2.5 py-1 rounded-full text-xs font-semibold bg-white/5 text-slate-400 border border-white/10 flex items-center space-x-1';
          this.showToast('Web Search Grounding: NONAKTIF');
        }
      }
    }

    sendChatMessage(text) {
      const clean = (text || '').trim();
      if (!clean) return;
      this.triggerHaptic('click');

      const nowStr = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
      this.chatMessages.push({
        id: `msg_${Date.now()}`,
        role: 'user',
        content: clean,
        timestamp: nowStr,
        webSearch: this.webSearchEnabled
      });

      this.renderChatScreen();
      this.scrollChatBottom();

      // Clear input
      const input = document.getElementById('chat-prompt-input');
      if (input) input.value = '';

      // Simulate Real-time SSE Token Streaming
      this.streamAssistantResponse(clean);
    }

    streamAssistantResponse(userPrompt) {
      const nowStr = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
      const ag = INITIAL_SEED_DATA.agents.find((a) => a.id === this.activeAgent) || INITIAL_SEED_DATA.agents[0];
      const assistantMsg = {
        id: `msg_${Date.now() + 1}`,
        role: 'assistant',
        agent: ag.id,
        content: '',
        timestamp: nowStr,
        webSearch: this.webSearchEnabled,
        citations: this.webSearchEnabled
          ? [
              {
                title: 'Apple VisionOS Spatial Human Interface Guidelines',
                url: 'https://developer.apple.com/design/human-interface-guidelines/visionos',
                domain: 'developer.apple.com',
                snippet: 'Glass material hierarchy, specular borders, and dynamic lighting principles for spatial computing.'
              },
              {
                title: 'Hermes Core Multimodal SSE Bridge Specification',
                url: 'https://hermes-agent.nousresearch.com/docs',
                domain: 'hermes-agent.nousresearch.com',
                snippet: 'Low-latency Server-Sent Events streaming and multi-agent specialist tool execution.'
              }
            ]
          : []
      };

      this.chatMessages.push(assistantMsg);
      this.renderChatScreen();

      let targetResponse = '';
      if (ag.id === 'tech_architect') {
        targetResponse = `### Analisis Arsitektur (${ag.name})\n\nPermintaan **"${userPrompt.slice(0, 60)}"** berhasil diproses melalui **Clean Architecture Pipeline**:\n\n\`\`\`typescript\n// Server-Sent Events Stream Bridge (TTFT <= 650ms)\nexport async function streamBridge(payload: ChatRequest) {\n  return new Response(sseStream, {\n    headers: { 'Content-Type': 'text/event-stream' }\n  });\n}\n\`\`\`\n\n- **Otorisasi:** JWT HS256 + RBAC Guard aktif.\n- **Spasial:** VisionOS Graphite Frost \`blur(24px) saturate(180%)\`.`;
      } else if (ag.id === 'business_analyst') {
        targetResponse = `### Ringkasan Strategis (${ag.name})\n\n| Metrik | Baseline | Hasil Implementasi |\n| :--- | :--- | :--- |\n| TTFT SSE Chat | <= 650 ms | Terpenuhi (480ms) |\n| Video Render | <= 45 dtk | Headless Remotion MP4 |\n| Mobile CI/CD | GitHub Actions | Unsigned .IPA Sideload |\n\nDisarankan mengonsolidasikan seluruh keluaran prompt ke dalam **Unified Media Vault** terenkripsi.`;
      } else if (ag.id === 'creative_director') {
        targetResponse = `### Arahan Seni & UX Spasial (${ag.name})\n\nUntuk merealisasikan **"${userPrompt.slice(0, 50)}"**, gunakan kaidah **VisionOS Spatial Glass**:\n\n1. **Refraksi Specular:** Border 1px \`rgba(255,255,255,0.22)\` dengan kurvatur squircle 24px.\n2. **Pencahayaan Volumetrik:** Pendar Electric Cyan (\`#38BDF8\`) dan Neural Violet (\`#818CF8\`).\n3. **Audio-Motion:** Animasi fluida 60 FPS sinkron dengan sintesis suara narasi.`;
      } else {
        targetResponse = `Halo! Saya **${ag.name}**. Saya telah memproses pesan Anda terkait **"${userPrompt.slice(0, 60)}"**.\n\n- **Multimodal Ready:** Siap melanjutkan obrolan, mengolah gambar di **Image Studio**, atau merender video di **Video Lab**.\n- **Kedaulatan Data:** Hasil tersimpan rapi di Vault lokal dengan enkripsi database SQLite.`;
      }

      const words = targetResponse.split(' ');
      let index = 0;
      const interval = setInterval(() => {
        if (index < words.length) {
          assistantMsg.content += (index === 0 ? '' : ' ') + words[index];
          index++;
          this.renderChatScreen();
          this.scrollChatBottom();
        } else {
          clearInterval(interval);
        }
      }, 35);
    }

    scrollChatBottom() {
      const scrollable = document.getElementById('chat-scroll-area');
      if (scrollable) {
        scrollable.scrollTop = scrollable.scrollHeight;
      }
    }

    // --- SCREEN 2: AI IMAGE STUDIO ---
    renderStudioScreen() {
      const gallery = document.getElementById('studio-gallery-grid');
      if (gallery) {
        gallery.innerHTML = this.imageGallery.map((img) => `
          <div class="relative group rounded-2xl overflow-hidden border border-white/15 bg-slate-900/60 shadow-lg">
            <img src="${img.url}" alt="${img.prompt}" class="w-full h-36 object-cover transition-transform duration-300 group-hover:scale-105" />
            <div class="absolute inset-0 bg-gradient-to-t from-slate-950/90 via-transparent to-transparent flex flex-col justify-end p-2.5">
              <span class="text-[10px] font-semibold text-sky-300 bg-black/50 px-2 py-0.5 rounded-full w-max border border-white/10 mb-1">${img.ratio} • ${img.style}</span>
              <p class="text-[11px] text-slate-200 line-clamp-1">${this.escapeHtml(img.prompt)}</p>
              <div class="flex items-center justify-between mt-1 text-[10px] text-slate-400">
                <span>Seed #${img.seed}</span>
                <button onclick="window.simulator.downloadImage('${img.url}')" class="text-sky-400 hover:text-sky-200 font-medium">⬇ Unduh</button>
              </div>
            </div>
          </div>
        `).join('');
      }
    }

    setStudioRatio(ratio) {
      this.selectedRatio = ratio;
      this.triggerHaptic('click');
      const ratios = ['1:1', '16:9', '9:16', '4:3'];
      ratios.forEach((r) => {
        const btn = document.getElementById(`ratio-btn-${r.replace(':', '-')}`);
        if (!btn) return;
        if (r === ratio) {
          btn.className = 'ratio-pill flex-1 py-1.5 rounded-xl text-xs font-semibold bg-white text-slate-950 shadow-md transition-all';
        } else {
          btn.className = 'ratio-pill flex-1 py-1.5 rounded-xl text-xs font-semibold bg-white/5 text-slate-300 border border-white/10 hover:bg-white/10 transition-all';
        }
      });
      this.showToast(`Rasio Aspek: ${ratio}`);
    }

    enhancePrompt() {
      const input = document.getElementById('studio-prompt-input');
      if (!input) return;
      this.triggerHaptic('click');
      const cur = input.value.trim() || 'A spatial holographic AI sphere';
      input.value = `${cur}, encased in graphite frost glass, Apple VisionOS aesthetic, cinematic volumetric lighting, 8K octane render, hyperminimalist`;
      this.showToast('✨ Magic Polish: Prompt telah dioptimasi!');
    }

    generateImage() {
      const input = document.getElementById('studio-prompt-input');
      const prompt = input ? input.value.trim() : '';
      if (!prompt) {
        this.showToast('Silakan tuliskan deskripsi prompt gambar terlebih dahulu.');
        return;
      }

      this.triggerHaptic('click');
      const loader = document.getElementById('studio-shimmer-loading');
      if (loader) loader.classList.remove('hidden');

      setTimeout(() => {
        if (loader) loader.classList.add('hidden');
        const seed = Math.floor(100000 + Math.random() * 899999);
        const ratio = this.selectedRatio || '1:1';
        const newImg = {
          id: `img_gen_${Date.now()}`,
          prompt,
          ratio,
          style: 'VisionOS Spatial Glass',
          resolution: ratio === '16:9' ? '1280x720' : ratio === '9:16' ? '720x1280' : '1024x1024',
          seed,
          url: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=1024&q=80',
          date: 'Baru saja'
        };
        this.imageGallery.unshift(newImg);
        this.vaultItems.unshift({
          id: `vlt_${Date.now()}`,
          title: prompt.slice(0, 32),
          type: 'image',
          thumb: newImg.url,
          detail: `Aspect ${ratio} • Seed #${seed} • PNG`,
          isFav: false
        });
        this.renderStudioScreen();
        this.showToast('✅ Gambar AI berhasil digenerasi & tersimpan di Vault!');
      }, 3000);
    }

    downloadImage(url) {
      this.triggerHaptic('click');
      const a = document.createElement('a');
      a.href = url;
      a.download = `Hermes-AI-${Date.now()}.jpg`;
      a.target = '_blank';
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      this.showToast('⬇️ Gambar disimpan ke Camera Roll / Unduhan.');
    }

    // --- SCREEN 3: AI VIDEO LAB (REMOTION ENGINE) ---
    renderVideoScreen() {
      const beats = document.getElementById('video-storyboard-beats');
      if (beats) {
        beats.innerHTML = INITIAL_SEED_DATA.videoStoryboard.map((b) => `
          <div class="flex items-center space-x-3 p-3 rounded-2xl bg-slate-900/60 border border-white/10 shadow-sm">
            <img src="${b.bg}" alt="${b.title}" class="w-14 h-14 rounded-xl object-cover shrink-0 border border-white/15" />
            <div class="flex-1 min-w-0">
              <div class="flex items-center justify-between mb-0.5">
                <span class="text-xs font-semibold text-slate-100 truncate">${b.title}</span>
                <span class="text-[10px] text-sky-400 font-mono bg-sky-500/10 px-1.5 py-0.5 rounded border border-sky-500/20">${b.time}</span>
              </div>
              <p class="text-[11px] text-slate-300 line-clamp-1 italic">"${b.script}"</p>
              <span class="text-[10px] text-slate-400 flex items-center space-x-1 mt-1">
                <span>🎙️</span><span>${b.speaker}</span>
              </span>
            </div>
          </div>
        `).join('');
      }
    }

    toggleVideoPlayback() {
      this.videoPlaying = !this.videoPlaying;
      this.triggerHaptic('click');
      const btn = document.getElementById('video-play-btn');
      if (btn) {
        btn.innerHTML = this.videoPlaying ? '⏸' : '▶';
      }

      if (this.videoPlaying) {
        this.runVideoLoop();
      } else {
        cancelAnimationFrame(this.videoRaf);
      }
    }

    runVideoLoop() {
      const tick = () => {
        if (!this.videoPlaying) return;
        this.videoProgress = (this.videoProgress + 0.35) % 100;
        const scrubber = document.getElementById('video-timeline-scrubber');
        const timeDisplay = document.getElementById('video-current-time');
        const overlayText = document.getElementById('remotion-overlay-text');

        if (scrubber) scrubber.value = this.videoProgress;
        const totalSec = 30;
        const curSec = (this.videoProgress / 100) * totalSec;
        if (timeDisplay) {
          timeDisplay.textContent = `00:${curSec < 10 ? '0' : ''}${curSec.toFixed(1)} / 00:30.0`;
        }

        if (overlayText) {
          if (curSec < 8) {
            overlayText.textContent = INITIAL_SEED_DATA.videoStoryboard[0].script;
          } else if (curSec < 20) {
            overlayText.textContent = INITIAL_SEED_DATA.videoStoryboard[1].script;
          } else {
            overlayText.textContent = INITIAL_SEED_DATA.videoStoryboard[2].script;
          }
        }

        this.videoRaf = requestAnimationFrame(tick);
      };
      this.videoRaf = requestAnimationFrame(tick);
    }

    renderVideoMP4() {
      const user = INITIAL_SEED_DATA.roles[this.currentRole];
      this.triggerHaptic('click');
      const progressDrawer = document.getElementById('video-render-progress-drawer');
      const progressBar = document.getElementById('video-render-bar');
      const progressText = document.getElementById('video-render-status-text');

      if (progressDrawer) progressDrawer.classList.remove('hidden');

      let pct = 0;
      const interval = setInterval(() => {
        pct += 12;
        if (pct <= 100) {
          if (progressBar) progressBar.style.width = `${pct}%`;
          if (progressText) {
            progressText.textContent = `Remotion Native Render (${user.videoResolution}): ${pct}% (Bingkai ${Math.floor((pct / 100) * 1800)}/1800)`;
          }
        } else {
          clearInterval(interval);
          setTimeout(() => {
            if (progressDrawer) progressDrawer.classList.add('hidden');
            this.showToast(`🎬 Video MP4 Selesai: Hermes Spatial Reel (${user.videoWatermark ? 'Watermarked' : 'Clean'})`);
            this.vaultItems.unshift({
              id: `vlt_vid_${Date.now()}`,
              title: 'Hermes Spatial Reel (Render Baru)',
              type: 'video',
              thumb: 'https://images.unsplash.com/photo-1634017839464-5c339ebe3cb4?w=400&q=80',
              detail: `${user.videoResolution} • 30s • MP4 H.264`,
              isFav: true
            });
            this.renderVaultScreen();
          }, 800);
        }
      }, 350);
    }

    // --- SCREEN 4: HANDS-FREE SPATIAL VOICE MODE ---
    toggleVoiceInteraction() {
      this.triggerHaptic('click');
      if (this.voiceState === 'idle') {
        this.setVoiceState('listening');
        this.voiceTranscript = 'Mendengarkan ucapan Anda... Silakan berbicara.';
        this.updateVoiceHUD();
      } else {
        this.setVoiceState('idle');
        this.voiceTranscript = 'Sesi suara dijeda. Ketuk tombol mic untuk melanjutkan.';
        this.updateVoiceHUD();
      }
    }

    // --- SCREEN 5: VAULT & SETTINGS ---
    renderVaultScreen() {
      const user = INITIAL_SEED_DATA.roles[this.currentRole];
      const nameEl = document.getElementById('vault-profile-name');
      const roleEl = document.getElementById('vault-profile-role');
      const tokenEl = document.getElementById('vault-profile-tokens');
      const avatarEl = document.getElementById('vault-profile-avatar');

      if (nameEl) nameEl.textContent = user.fullName;
      if (roleEl) roleEl.textContent = user.roleName;
      if (tokenEl) tokenEl.textContent = `${user.quotaTokens.toLocaleString()} TKN`;
      if (avatarEl) avatarEl.src = user.avatarUrl;

      const grid = document.getElementById('vault-items-grid');
      if (grid) {
        const filtered = this.vaultItems.filter((item) => {
          if (this.currentFilter === 'all') return true;
          if (this.currentFilter === 'fav') return item.isFav;
          return item.type === this.currentFilter;
        });

        grid.innerHTML = filtered.map((item) => `
          <div class="relative group rounded-2xl overflow-hidden border border-white/10 bg-slate-900/60 p-2.5 shadow-md flex items-center space-x-3">
            <img src="${item.thumb}" alt="${item.title}" class="w-14 h-14 rounded-xl object-cover shrink-0 border border-white/15" />
            <div class="flex-1 min-w-0">
              <div class="flex items-center justify-between">
                <span class="text-xs font-semibold text-slate-200 truncate">${this.escapeHtml(item.title)}</span>
                <span class="text-xs">${item.isFav ? '⭐' : ''}</span>
              </div>
              <p class="text-[11px] text-slate-400 truncate mt-0.5">${item.detail}</p>
              <div class="flex items-center space-x-2 mt-1">
                <span class="text-[9px] uppercase px-1.5 py-0.5 rounded bg-white/5 border border-white/10 text-slate-300 font-mono">${item.type}</span>
                <button onclick="window.simulator.deleteVaultItem('${item.id}')" class="text-[10px] text-rose-400 hover:text-rose-200 font-medium">Hapus</button>
              </div>
            </div>
          </div>
        `).join('');
      }
    }

    setVaultFilter(filterType) {
      this.currentFilter = filterType;
      this.triggerHaptic('click');
      const filters = ['all', 'image', 'video', 'audio', 'fav'];
      filters.forEach((f) => {
        const btn = document.getElementById(`filter-btn-${f}`);
        if (!btn) return;
        if (f === filterType) {
          btn.className = 'px-3 py-1 rounded-full text-xs font-semibold bg-white text-slate-950 shadow-sm transition-all';
        } else {
          btn.className = 'px-3 py-1 rounded-full text-xs font-semibold bg-white/5 text-slate-300 border border-white/10 hover:bg-white/10 transition-all';
        }
      });
      this.renderVaultScreen();
    }

    deleteVaultItem(id) {
      const user = INITIAL_SEED_DATA.roles[this.currentRole];
      if (!user.canDeleteVault) {
        this.showToast('Akses Ditolak: Guest tidak diizinkan menghapus aset Vault.');
        return;
      }
      this.triggerHaptic('click');
      this.vaultItems = this.vaultItems.filter((i) => i.id !== id);
      this.renderVaultScreen();
      this.showToast('Item berhasil dihapus dari Vault.');
    }

    testBackendConnection() {
      this.triggerHaptic('click');
      const statusEl = document.getElementById('backend-ping-status');
      if (statusEl) {
        statusEl.textContent = 'Menguji koneksi ke Hermes Bridge...';
        statusEl.className = 'text-xs text-sky-400 animate-pulse mt-1';
      }

      fetch('/api/v1/health')
        .then((r) => r.json())
        .then((data) => {
          if (statusEl) {
            statusEl.textContent = `🟢 Terhubung: ${data.data?.service || 'Hermes Bridge'} (Mode: ${data.data?.mode || 'hybrid'}) • Ping: 18ms`;
            statusEl.className = 'text-xs text-emerald-400 font-medium mt-1';
          }
          this.showToast('Koneksi Backend Bridge Aktif!');
        })
        .catch(() => {
          if (statusEl) {
            statusEl.textContent = '🟢 Mode Demo Standalone Simulator Aktif (Fallback Lokal OK)';
            statusEl.className = 'text-xs text-sky-400 font-medium mt-1';
          }
          this.showToast('Simulator berjalan dalam Mode Evaluasi Mandiri.');
        });
    }

    // --- UTILITIES ---
    escapeHtml(str) {
      if (!str) return '';
      return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
    }

    formatMarkdown(text) {
      if (!text) return '';
      let out = this.escapeHtml(text);

      // Code blocks
      out = out.replace(/```([a-z0-9_-]*)\n([\s\S]*?)```/gi, (_match, lang, code) => {
        return `
          <div class="my-2 rounded-xl overflow-hidden bg-slate-950 border border-white/10 font-mono text-xs">
            <div class="flex items-center justify-between px-3 py-1.5 bg-white/5 border-b border-white/10 text-[10px] text-slate-400">
              <span>${lang || 'code'}</span>
              <button onclick="navigator.clipboard.writeText(this.dataset.code); window.simulator.showToast('Teks disalin ke clipboard!');" data-code="${code.replace(/"/g, '&quot;')}" class="text-sky-400 hover:text-sky-300">Copy</button>
            </div>
            <pre class="p-3 overflow-x-auto text-sky-200"><code>${code}</code></pre>
          </div>
        `;
      });

      // Inline code
      out = out.replace(/`([^`]+)`/g, '<code class="px-1.5 py-0.5 rounded bg-white/10 text-sky-300 font-mono text-[12px]">$1</code>');

      // Bold & Italic
      out = out.replace(/\*\*([^*]+)\*\*/g, '<strong class="font-bold text-white">$1</strong>');
      out = out.replace(/\*([^*]+)\*/g, '<em class="italic text-slate-300">$1</em>');

      // Headings
      out = out.replace(/^### (.*$)/gim, '<h4 class="font-bold text-white text-sm mt-2 mb-1">$1</h4>');
      out = out.replace(/^## (.*$)/gim, '<h3 class="font-bold text-white text-base mt-2 mb-1">$1</h3>');

      // Lists
      out = out.replace(/^\- (.*$)/gim, '<div class="flex items-start space-x-1.5"><span class="text-sky-400">•</span><span>$1</span></div>');

      // Line breaks
      out = out.replace(/\n\n/g, '<div class="h-2"></div>');

      return out;
    }

    setupDOM() {
      // Bind enter key on chat prompt
      const chatInput = document.getElementById('chat-prompt-input');
      if (chatInput) {
        chatInput.addEventListener('keydown', (e) => {
          if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            this.sendChatMessage(chatInput.value);
          }
        });
      }
    }

    setupEventListeners() {
      // Close popover when clicked outside
      document.addEventListener('click', (e) => {
        const popover = document.getElementById('role-switcher-popover');
        const pill = document.getElementById('role-switcher-pill-btn');
        if (popover && pill && !popover.contains(e.target) && !pill.contains(e.target)) {
          popover.classList.add('hidden');
        }
      });
    }

    toggleRolePopover() {
      this.triggerHaptic('click');
      const popover = document.getElementById('role-switcher-popover');
      if (popover) {
        popover.classList.toggle('hidden');
      }
    }
  }

  // Instantiate and mount globally
  window.simulator = new SimulatorController();
  window.addEventListener('DOMContentLoaded', () => {
    window.simulator.init();
  });
})();
