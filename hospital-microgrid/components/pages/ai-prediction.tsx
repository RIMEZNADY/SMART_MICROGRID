"use client"

import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Legend } from "recharts"
import MetricCard from "@/components/metric-card"
import { Brain, TrendingUp, AlertTriangle, Zap } from "lucide-react"

const predictionData = [
  { hour: "0", predicted: 2400, actual: 2400, confidence: 98 },
  { hour: "2", predicted: 2210, actual: 2290, confidence: 97 },
  { hour: "4", predicted: 2290, actual: 2000, confidence: 96 },
  { hour: "6", predicted: 2000, actual: 2181, confidence: 95 },
  { hour: "8", predicted: 2181, actual: 2500, confidence: 94 },
  { hour: "10", predicted: 2500, actual: 2100, confidence: 93 },
  { hour: "12", predicted: 2100, actual: 2800, confidence: 92 },
]

export default function AIPrediction() {
  return (
    <div className="max-w-7xl mx-auto px-6 py-8">
      <div className="mb-8">
        <h2 className="text-3xl font-bold text-foreground mb-2">AI Energy Prediction</h2>
        <p className="text-muted-foreground">Machine learning-powered 24-hour energy demand forecasting</p>
      </div>

      {/* Prediction Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
        <MetricCard icon={Brain} label="Model Accuracy" value="96.2%" change="+2.1%" color="from-primary to-accent" />
        <MetricCard
          icon={TrendingUp}
          label="24h Forecast"
          value="2.45 MW"
          change="+3.2%"
          color="from-accent to-secondary"
        />
        <MetricCard
          icon={AlertTriangle}
          label="Peak Alert"
          value="3.2 MW"
          change="at 14:00"
          color="from-secondary to-primary"
        />
        <MetricCard
          icon={Zap}
          label="Recommended Load"
          value="2.1 MW"
          change="-8.5%"
          color="from-primary to-secondary"
        />
      </div>

      {/* Prediction Chart */}
      <div className="bg-card border border-border rounded-lg p-6 mb-6">
        <h3 className="text-lg font-semibold text-card-foreground mb-4">24-Hour Prediction vs Actual</h3>
        <ResponsiveContainer width="100%" height={400}>
          <LineChart data={predictionData}>
            <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.1)" />
            <XAxis dataKey="hour" stroke="rgba(255,255,255,0.5)" />
            <YAxis stroke="rgba(255,255,255,0.5)" />
            <Tooltip
              contentStyle={{ backgroundColor: "rgba(15, 23, 42, 0.9)", border: "1px solid rgba(255,255,255,0.1)" }}
            />
            <Legend />
            <Line
              type="monotone"
              dataKey="predicted"
              stroke="hsl(262, 80%, 50%)"
              strokeWidth={2}
              strokeDasharray="5 5"
              dot={false}
            />
            <Line type="monotone" dataKey="actual" stroke="hsl(180, 100%, 50%)" strokeWidth={2} dot={false} />
          </LineChart>
        </ResponsiveContainer>
      </div>

      {/* AI Insights */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-card border border-border rounded-lg p-6">
          <h3 className="text-lg font-semibold text-card-foreground mb-4">Key Insights</h3>
          <ul className="space-y-3">
            <li className="flex items-start gap-3">
              <div className="w-2 h-2 rounded-full bg-accent mt-2"></div>
              <div>
                <p className="text-card-foreground font-medium">Peak Load Expected</p>
                <p className="text-muted-foreground text-sm">3.2 MW at 14:00 - prepare battery discharge</p>
              </div>
            </li>
            <li className="flex items-start gap-3">
              <div className="w-2 h-2 rounded-full bg-accent mt-2"></div>
              <div>
                <p className="text-card-foreground font-medium">Solar Generation Optimal</p>
                <p className="text-muted-foreground text-sm">Expected 2.8 MW between 10:00-16:00</p>
              </div>
            </li>
            <li className="flex items-start gap-3">
              <div className="w-2 h-2 rounded-full bg-accent mt-2"></div>
              <div>
                <p className="text-card-foreground font-medium">Grid Demand Low</p>
                <p className="text-muted-foreground text-sm">Opportunity to charge batteries at 02:00-06:00</p>
              </div>
            </li>
          </ul>
        </div>

        <div className="bg-card border border-border rounded-lg p-6">
          <h3 className="text-lg font-semibold text-card-foreground mb-4">Recommendations</h3>
          <ul className="space-y-3">
            <li className="flex items-start gap-3">
              <div className="w-2 h-2 rounded-full bg-primary mt-2"></div>
              <div>
                <p className="text-card-foreground font-medium">Optimize Battery Charging</p>
                <p className="text-muted-foreground text-sm">Charge during low-demand hours to maximize efficiency</p>
              </div>
            </li>
            <li className="flex items-start gap-3">
              <div className="w-2 h-2 rounded-full bg-primary mt-2"></div>
              <div>
                <p className="text-card-foreground font-medium">Shift Non-Critical Loads</p>
                <p className="text-muted-foreground text-sm">Move maintenance tasks to 02:00-06:00 window</p>
              </div>
            </li>
            <li className="flex items-start gap-3">
              <div className="w-2 h-2 rounded-full bg-primary mt-2"></div>
              <div>
                <p className="text-card-foreground font-medium">Prepare for Peak Hours</p>
                <p className="text-muted-foreground text-sm">Ensure 85% battery charge before 12:00</p>
              </div>
            </li>
          </ul>
        </div>
      </div>
    </div>
  )
}
