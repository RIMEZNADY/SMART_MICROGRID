"use client"

import { useState } from "react"
import Navigation from "@/components/navigation"
import Dashboard from "@/components/pages/dashboard"
import AIPrediction from "@/components/pages/ai-prediction"
import AutoLearning from "@/components/pages/auto-learning"
import History from "@/components/pages/history"

export default function Home() {
  const [currentPage, setCurrentPage] = useState("dashboard")

  const renderPage = () => {
    switch (currentPage) {
      case "dashboard":
        return <Dashboard />
      case "ai-prediction":
        return <AIPrediction />
      case "auto-learning":
        return <AutoLearning />
      case "history":
        return <History />
      default:
        return <Dashboard />
    }
  }

  return (
    <div className="min-h-screen bg-background text-foreground">
      <Navigation currentPage={currentPage} onPageChange={setCurrentPage} />
      <main className="pt-20">{renderPage()}</main>
    </div>
  )
}
