import { Controller } from "@hotwired/stimulus"
import anime from "animejs/lib/anime.es.js"

// data-controller="profile"
export default class extends Controller {
  connect() {
    console.log("Profile animations loaded ✅")

    // Animar las filas de órdenes
    anime({
      targets: ".order-item",
      translateY: [50, 0],
      opacity: [0, 1],
      delay: anime.stagger(200),
      easing: "easeOutExpo",
      duration: 1000
    })

    // Animar la tarjeta de estadísticas
    anime({
      targets: ".stats-card",
      scale: [0.8, 1],
      opacity: [0, 1],
      delay: 500,
      easing: "easeOutElastic(1, .6)",
      duration: 1200
    })
  }
}
