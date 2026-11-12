export const ROLE_SLUGS = Object.freeze({
  SUPERADMIN: 'superadmin',
  PRO_CREATOR: 'pro_creator',
  CONSUMER: 'consumer',
  GUEST: 'guest'
});

export const ROLE_POLICIES = Object.freeze({
  superadmin: {
    label: 'Superadmin',
    maxUploadBytes: 20 * 1024 * 1024,
    maxVideoDurationSec: 120,
    videoWatermark: false,
    videoResolution: '1080p',
    canSwitchAgents: true,
    canEditServerSettings: true,
    canDeleteVault: true,
    canExportVault: true,
    rateLimitPerMin: 240
  },
  pro_creator: {
    label: 'Pro Creator',
    maxUploadBytes: 10 * 1024 * 1024,
    maxVideoDurationSec: 60,
    videoWatermark: false,
    videoResolution: '1080p',
    canSwitchAgents: true,
    canEditServerSettings: true,
    canDeleteVault: true,
    canExportVault: true,
    rateLimitPerMin: 120
  },
  consumer: {
    label: 'Consumer',
    maxUploadBytes: 5 * 1024 * 1024,
    maxVideoDurationSec: 15,
    videoWatermark: true,
    videoResolution: '720p',
    canSwitchAgents: false,
    canEditServerSettings: false,
    canDeleteVault: true,
    canExportVault: true,
    rateLimitPerMin: 40
  },
  guest: {
    label: 'Guest',
    maxUploadBytes: 2 * 1024 * 1024,
    maxVideoDurationSec: 10,
    videoWatermark: true,
    videoResolution: '720p',
    canSwitchAgents: false,
    canEditServerSettings: false,
    canDeleteVault: false,
    canExportVault: false,
    rateLimitPerMin: 15
  }
});

export const SPECIALIST_AGENTS = Object.freeze([
  {
    id: 'general',
    name: 'Lead Orchestrator',
    role: 'Multi-Domain Reasoning',
    badge: 'DEFAULT',
    accent: '#38BDF8',
    description: 'Asisten serbaguna dengan penalaran cepat, web search grounding, dan analisis visual.'
  },
  {
    id: 'tech_architect',
    name: 'Fullstack Architect',
    role: 'Systems, API & Mobile CI/CD',
    badge: 'PRO',
    accent: '#818CF8',
    description: 'Spesialis Clean Architecture, optimasi SSE streaming, SwiftUI/Flutter, dan Remotion.'
  },
  {
    id: 'creative_director',
    name: 'Art & UX Director',
    role: 'VisionOS Spatial & Prompt Craft',
    badge: 'PRO',
    accent: '#C084FC',
    description: 'Merancang komposisi visual sinematik, skrip storyboard video, dan palet spatial glass.'
  },
  {
    id: 'business_analyst',
    name: 'Business & Market Analyst',
    role: 'KPI, ROI & Strategy Matrix',
    badge: 'PRO',
    accent: '#10B981',
    description: 'Menghasilkan ringkasan eksekutif terstruktur, tabel KPI, dan riset kompetitor.'
  }
]);

export function getRolePolicy(roleSlug) {
  return ROLE_POLICIES[roleSlug] || ROLE_POLICIES.guest;
}
