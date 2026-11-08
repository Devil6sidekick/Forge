forge/
├── infra/
│   ├── terraform/   → modules (vpc, eks) + one folder per environment
│   ├── packer/      → hardened node image (golden AMI)
│   └── ansible/     → hardening roles
├── gitops/
│   ├── platform/    → ArgoCD, Vault, Kyverno, monitoring
│   └── apps/        → Pitstop (dev / prod)
├── ci/              → CI pipelines
└── docs/
    └── decisions.md → one line per technical choice and why (great material for interviews)
