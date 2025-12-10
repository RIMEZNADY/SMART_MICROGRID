"use client"

import { BarChart, Bar, LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from "recharts"
import MetricCard from "@/components/metric-card"
import { Zap, TrendingUp, Target, Activity } from "lucide-react"

const learningData = [
  { day: "Mon", accuracy: 88, efficiency: 82 },
  { day: "Tue", accuracy: 90, efficiency: 84 },
  { day: "Wed", accuracy: 92, efficiency: 86 },
  { day: "Thu", accuracy: 94, efficiency: 88 },
  { day: "Fri", accuracy: 95, efficiency: 90 },
  { day: "Sat", accuracy: 96, efficiency: 91 },
  { day: "Sun", accuracy: 96, efficiency: 92 },
]

const patternData = [
  { pattern: "Morning Peak", frequency: 95, impact: "High" },
  { pattern: "Afternoon Dip", frequency: 87, impact: "Medium" },
  { pattern: "Evening Surge", frequency: 92, impact: "High" },
  { pattern: "Night Low", frequency: 100, impact: "Low" },
]

export default function AutoLearning() {
  return (
    <div className="max-w-7xl mx-auto px-6 py-8">
      <div className="mb-8">
        <h2 className="text-3xl font-bold text-foreground mb-2">Auto-Learning Monitor</h2>
        <p className="text-muted-foreground">Self-learning system continuously improving energy management</p>
      </div>

      {/* Learning Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
        <MetricCard
          icon={Target}
          label="Learning Progress"
          value="96%"
          change="+8% this week"
          color="from-primary to-accent"
        />
        <MetricCard
          icon={TrendingUp}
          label="Accuracy Improvement"
          value="+8.2%"
          change="vs baseline"
          color="from-accent to-secondary"
        />
        <MetricCard
          icon={Activity}
          label="Patterns Learned"
          value="24"
          change="+3 new patterns"
          color="from-secondary to-primary"
        />
        <MetricCard
          icon={Zap}
          label="Energy Saved"
          value="12.4%"
          change="this month"
          color="from-primary to-secondary"
        />
      </div>

      {/* Learning Progress */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
        <div className="bg-card border border-border rounded-lg p-6">
          <h3 className="text-lg font-semibold text-card-foreground mb-4">Weekly Learning Progress</h3>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={learningData}>
              <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.1)" />
              <XAxis dataKey="day" stroke="rgba(255,255,255,0.5)" />
              <YAxis stroke="rgba(255,255,255,0.5)" />
              <Tooltip
                contentStyle={{ backgroundColor: "rgba(15, 23, 42, 0.9)", border: "1px solid rgba(255,255,255,0.1)" }}
              />
              <Bar dataKey="accuracy" fill="hsl(180, 100%, 50%)" radius={[8, 8, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>

        <div className="bg-card border border-border rounded-lg p-6">
          <h3 className="text-lg font-semibold text-card-foreground mb-4">Efficiency Improvement</h3>
          <ResponsiveContainer width="100%" height={300}>
            <LineChart data={learningData}>
              <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.1)" />
              <XAxis dataKey="day" stroke="rgba(255,255,255,0.5)" />
              <YAxis stroke="rgba(255,255,255,0.5)" />
              <Tooltip
                contentStyle={{ backgroundColor: "rgba(15, 23, 42, 0.9)", border: "1px solid rgba(255,255,255,0.1)" }}
              />
              <Line type="monotone" dataKey="efficiency" stroke="hsl(262, 80%, 50%)" strokeWidth={2} dot={false} />
            </LineChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* Learned Patterns */}
      <div className="bg-card border border-border rounded-lg p-6">
        <h3 className="text-lg font-semibold text-card-foreground mb-4">Discovered Energy Patterns</h3>
        <div className="space-y-4">
          {patternData.map((pattern, idx) => (
            <div
              key={idx}
              className="flex items-center justify-between p-4 bg-muted/30 rounded-lg border border-border/50"
            >
              <div>
                <p className="text-card-foreground font-medium">{pattern.pattern}</p>
                <p className="text-muted-foreground text-sm">
                  Frequency: {pattern.frequency}% | Impact: {pattern.impact}
                </p>
              </div>
              <div className="w-32 h-2 bg-muted rounded-full overflow-hidden">
                <div
                  className="h-full bg-gradient-to-r from-primary to-accent"
                  style={{ width: `${pattern.frequency}%` }}
                ></div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
