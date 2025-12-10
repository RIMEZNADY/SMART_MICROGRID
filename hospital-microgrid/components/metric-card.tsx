import type { LucideIcon } from "lucide-react"

interface MetricCardProps {
  icon: LucideIcon
  label: string
  value: string
  change: string
  color: string
}

export default function MetricCard({ icon: Icon, label, value, change, color }: MetricCardProps) {
  return (
    <div className="bg-card border border-border rounded-lg p-6 hover:border-accent/50 transition-colors">
      <div className="flex items-start justify-between mb-4">
        <div className={`w-12 h-12 rounded-lg bg-gradient-to-br ${color} flex items-center justify-center`}>
          <Icon className="w-6 h-6 text-primary-foreground" />
        </div>
      </div>
      <p className="text-muted-foreground text-sm mb-1">{label}</p>
      <p className="text-2xl font-bold text-card-foreground mb-2">{value}</p>
      <p className="text-xs text-accent">{change}</p>
    </div>
  )
}
