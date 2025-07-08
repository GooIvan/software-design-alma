// Import básico de Rails
import "@hotwired/turbo-rails";
import "controllers";

import { initSidebar } from "custom/init_sidebar";
import { initChangeLanguage } from "custom/init_change_lenguage";
import { initChartJsUsersLastMonth } from "custom/init_chart_js_users_last_month";
import { initCarouselImages } from "custom/init_carousel_images";

// Mostrar el loader al iniciar una navegación Turbo
document.addEventListener("turbo:visit", () => {
  const loader = document.getElementById("loading-overlay");
  if (loader) loader.classList.remove("hidden");
});

// Ocultar el loader al terminar la carga
document.addEventListener("turbo:load", () => {
  const loader = document.getElementById("loading-overlay");
  if (loader) {
    setTimeout(() => {
      loader.classList.add("hidden");
    }, 100); // ajusta el delay si quieres
  }

  //* === Iconos ===
  try {
    if (window.feather) feather.replace();
  } catch (e) {
    console.warn("Feather error:", e);
  }

  //* === Sidebar ===
  try {
    initSidebar();
  } catch (e) {
    console.warn("Sidebar error:", e);
  }

  //* === CAMBIO DE IDIOMA ===
  try {
    initChangeLanguage();
  } catch (e) {
    console.warn("Change language error:", e);
  }

  //* === CHART.JS: Usuarios por mes ===
  try {
    initChartJsUsersLastMonth();
  } catch (e) {
    console.warn("Chart.js error:", e);
  }

  // * === CAROUSEL DE IMÁGENES ===
  try {
    initCarouselImages();
  } catch (e) {
    console.warn("Carousel error:", e);
  }
});
