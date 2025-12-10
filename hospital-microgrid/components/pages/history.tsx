"use client"

import { LineChart, Line, AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from "recharts"
import MetricCard from "@/components/metric-card"
import { Calendar, TrendingDown, TrendingUp, Zap } from "lucide-react"

const monthlyData = [
  { month: "Jan", consumption: 2400, generation: 1200, savings: 400 },
  { month: "Feb", consumption: 2210, generation: 1290, savings: 450 },
  { month: "Mar", consumption: 2290, generation: 1500, savings: 520 },
  { month: "Apr", consumption: 2000, generation: 1800, savings: 580 },
  { month: "May", consumption: 2181, generation: 2100, savings: 650 },
  { month: "Jun", consumption: 2500, generation: 2300, savings: 720 },
]

const dailyData = [
  { date: "1", load: 2400, solar: 1200 },
  { date: "5", load: 2210, solar: 1290 },
  { date: "10", load: 2290, solar: 1500 },
  { date: "15", load: 2000, solar: 1800 },
  { date: "20", load: 2181, solar: 2100 },
  { date: "25", load: 2500, solar: 2300 },
  { date: "30", load: 2400, solar: 2200 },
]

export default function History() {
  return (
    <div className="max-w-7xl mx-auto px-6 py-8">
      <div className="mb-8">
        <h2 className="text-3xl font-bold text-foreground mb-2">Historical Analytics</h2>
        <p className="text-muted-foreground">Long-term energy consumption and generation trends</p>
      </div>

      {/* History Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
        <MetricCard
          icon={Calendar}
          label="Total Consumption"
          value="14.58 MWh"
          change="this month"
          color="from-primary to-accent"
        />
        <MetricCard
          icon={TrendingUp}
          label="Total Generation"
          value="10.29 MWh"
          change="+15.2%"
          color="from-accent to-secondary"
        />
        <MetricCard
          icon={TrendingDown}
          label="Total Savings"
          value="3.29 MWh"
          change="+22.5%"
          color="from-secondary to-primary"
        />
        <MetricCard icon={Zap} label="Avg Efficiency" value="70.6%" change="+5.8%" color="from-primary to-secondary" />
      </div>

      {/* Monthly Trends */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
        <div className="bg-card border border-border rounded-lg p-6">
          <h3 className="text-lg font-semibold text-card-foreground mb-4">Monthly Consumption vs Generation</h3>
          <ResponsiveContainer width="100%" height={300}>
            <AreaChart data={monthlyData}>
              <defs>
                <linearGradient id="colorConsumption" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="hsl(262, 80%, 50%)" stopOpacity={0.8} />
                  <stop offset="95%" stopColor="hsl(262, 80%, 50%)" stopOpacity={0} />
                </linearGradient>
                <linearGradient id="colorGeneration" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="hsl(180, 100%, 50%)" stopOpacity={0.8} />
                  <stop offset="95%" stopColor="hsl(180, 100%, 50%)" stopOpacity={0} />
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.1)" />
              <XAxis dataKey="month" stroke="rgba(255,255,255,0.5)" />
              <YAxis stroke="rgba(255,255,255,0.5)" />
              <Tooltip
                contentStyle={{ backgroundColor: "rgba(15, 23, 42, 0.9)", border: "1px solid rgba(255,255,255,0.1)" }}
              />
              <Area
                type="monotone"
                dataKey="consumption"
                stackId="1"
                stroke="hsl(262, 80%, 50%)"
                fillOpacity={1}
                fill="url(#colorConsumption)"
              />
              <Area
                type="monotone"
                dataKey="generation"
                stackId="1"
                stroke="hsl(180, 100%, 50%)"
                fillOpacity={1}
                fill="url(#colorGeneration)"
              />
            </AreaChart>
          </ResponsiveContainer>
        </div>

        <div className="bg-card border border-border rounded-lg p-6">
          <h3 className="text-lg font-semibold text-card-foreground mb-4">Monthly Savings Trend</h3>
          <ResponsiveContainer width="100%" height={300}>
            <LineChart data={monthlyData}>
              <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.1)" />
              <XAxis dataKey="month" stroke="rgba(255,255,255,0.5)" />
              <YAxis stroke="rgba(255,255,255,0.5)" />
              <Tooltip
                contentStyle={{ backgroundColor: "rgba(15, 23, 42, 0.9)", border: "1px solid rgba(255,255,255,0.1)" }}
              />
              <Line type="monotone" dataKey="savings" stroke="hsl(180, 100%, 50%)" strokeWidth={2} dot={false} />
            </LineChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* Daily Breakdown */}
      <div className="bg-card border border-border rounded-lg p-6">
        <h3 className="text-lg font-semibold text-card-foreground mb-4">Daily Load vs Solar Generation</h3>
        <ResponsiveContainer width="100%" height={300}>
          <LineChart data={dailyData}>
            <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.1)" />
            <XAxis dataKey="date" stroke="rgba(255,255,255,0.5)" />
            <YAxis stroke="rgba(255,255,255,0.5)" />
            <Tooltip
              contentStyle={{ backgroundColor: "rgba(15, 23, 42, 0.9)", border: "1px solid rgba(255,255,255,0.1)" }}
            />
            <Line type="monotone" dataKey="load" stroke="hsl(262, 80%, 50%)" strokeWidth={2} dot={false} />
            <Line type="monotone" dataKey="solar" stroke="hsl(180, 100%, 50%)" strokeWidth={2} dot={false} />
          </LineChart>
        </ResponsiveContainer>
      </div>
    </div>
  )
}
