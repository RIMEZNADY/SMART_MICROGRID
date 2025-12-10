"use client"

import {
  LineChart,
  Line,
  AreaChart,
  Area,
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  Legend,
} from "recharts"
import MetricCard from "@/components/metric-card"
import { Activity, AlertCircle, TrendingUp, Zap } from "lucide-react"

const energyData = [
  { time: "00:00", solar: 0, grid: 2400, battery: 1200, load: 2800 },
  { time: "04:00", solar: 100, grid: 2210, battery: 1290, load: 2000 },
  { time: "08:00", solar: 2290, grid: 1200, battery: 800, load: 2181 },
  { time: "12:00", solar: 3490, grid: 400, battery: 0, load: 2500 },
  { time: "16:00", solar: 2100, grid: 1398, battery: 500, load: 2100 },
  { time: "20:00", solar: 200, grid: 2800, battery: 1200, load: 2800 },
  { time: "24:00", solar: 0, grid: 2400, battery: 1200, load: 2800 },
]

const efficiencyData = [
  { hour: "00", efficiency: 78 },
  { hour: "04", efficiency: 82 },
  { hour: "08", efficiency: 88 },
  { hour: "12", efficiency: 95 },
  { hour: "16", efficiency: 92 },
  { hour: "20", efficiency: 85 },
  { hour: "24", efficiency: 80 },
]

export default function Dashboard() {
  return (
    <div className="max-w-7xl mx-auto px-6 py-8">
      <div className="mb-8">
        <h2 className="text-3xl font-bold text-foreground mb-2">Energy Dashboard</h2>
        <p className="text-muted-foreground">Real-time hospital microgrid monitoring and analytics</p>
      </div>

      {/* Metric Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
        <MetricCard icon={Zap} label="Current Load" value="2.8 MW" change="+2.4%" color="from-primary to-accent" />
        <MetricCard
          icon={TrendingUp}
          label="Solar Generation"
          value="1.2 MW"
          change="+12.5%"
          color="from-accent to-secondary"
        />
        <MetricCard
          icon={Activity}
          label="System Efficiency"
          value="92%"
          change="+5.2%"
          color="from-secondary to-primary"
        />
        <MetricCard
          icon={AlertCircle}
          label="Battery Status"
          value="78%"
          change="-1.8%"
          color="from-primary to-secondary"
        />
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
        {/* Energy Flow Chart */}
        <div className="bg-card border border-border rounded-lg p-6">
          <h3 className="text-lg font-semibold text-card-foreground mb-4">Energy Flow (24h)</h3>
          <ResponsiveContainer width="100%" height={300}>
            <AreaChart data={energyData}>
              <defs>
                <linearGradient id="colorSolar" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="hsl(180, 100%, 50%)" stopOpacity={0.8} />
                  <stop offset="95%" stopColor="hsl(180, 100%, 50%)" stopOpacity={0} />
                </linearGradient>
                <linearGradient id="colorGrid" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="hsl(262, 80%, 50%)" stopOpacity={0.8} />
                  <stop offset="95%" stopColor="hsl(262, 80%, 50%)" stopOpacity={0} />
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.1)" />
              <XAxis dataKey="time" stroke="rgba(255,255,255,0.5)" />
              <YAxis stroke="rgba(255,255,255,0.5)" />
              <Tooltip
                contentStyle={{ backgroundColor: "rgba(15, 23, 42, 0.9)", border: "1px solid rgba(255,255,255,0.1)" }}
              />
              <Area
                type="monotone"
                dataKey="solar"
                stackId="1"
                stroke="hsl(180, 100%, 50%)"
                fillOpacity={1}
                fill="url(#colorSolar)"
              />
              <Area
                type="monotone"
                dataKey="grid"
                stackId="1"
                stroke="hsl(262, 80%, 50%)"
                fillOpacity={1}
                fill="url(#colorGrid)"
              />
            </AreaChart>
          </ResponsiveContainer>
        </div>

        {/* Efficiency Chart */}
        <div className="bg-card border border-border rounded-lg p-6">
          <h3 className="text-lg font-semibold text-card-foreground mb-4">System Efficiency</h3>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={efficiencyData}>
              <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.1)" />
              <XAxis dataKey="hour" stroke="rgba(255,255,255,0.5)" />
              <YAxis stroke="rgba(255,255,255,0.5)" />
              <Tooltip
                contentStyle={{ backgroundColor: "rgba(15, 23, 42, 0.9)", border: "1px solid rgba(255,255,255,0.1)" }}
              />
              <Bar dataKey="efficiency" fill="hsl(180, 100%, 50%)" radius={[8, 8, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* Load Distribution */}
      <div className="bg-card border border-border rounded-lg p-6">
        <h3 className="text-lg font-semibold text-card-foreground mb-4">Load Distribution</h3>
        <ResponsiveContainer width="100%" height={300}>
          <LineChart data={energyData}>
            <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.1)" />
            <XAxis dataKey="time" stroke="rgba(255,255,255,0.5)" />
            <YAxis stroke="rgba(255,255,255,0.5)" />
            <Tooltip
              contentStyle={{ backgroundColor: "rgba(15, 23, 42, 0.9)", border: "1px solid rgba(255,255,255,0.1)" }}
            />
            <Legend />
            <Line type="monotone" dataKey="load" stroke="hsl(180, 100%, 50%)" strokeWidth={2} dot={false} />
            <Line type="monotone" dataKey="battery" stroke="hsl(200, 100%, 50%)" strokeWidth={2} dot={false} />
          </LineChart>
        </ResponsiveContainer>
      </div>
    </div>
  )
}
