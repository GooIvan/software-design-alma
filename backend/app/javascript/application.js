// Import básico de Rails
import "@hotwired/turbo-rails";
import "controllers";

import { initSidebar } from "custom/init_sidebar";
import { initDarkMode } from "custom/init_dark_mode";
import { initChangeLanguage } from "custom/init_change_lenguage";
import { initCarouselImages } from "custom/init_carousel_images";
import { initChartJsLastMonth } from "custom/init_chart_js_last_month";
import { initChartJsPie } from "custom/init_chart_js_pie";
import { initOrderItems } from "custom/admin/init_order_items";

// Mostrar el loader al iniciar una navegación Turbo
document.addEventListener("turbo:visit", () => {
  const loader = document.getElementById("loading-overlay");
  if (loader) {
    loader.style.display = "flex";
    loader.classList.remove("hidden");
  }
});

// Ocultar el loader al terminar la carga
document.addEventListener("turbo:load", () => {
  const loader = document.getElementById("loading-overlay");
  if (loader) {
    setTimeout(() => {
      loader.classList.add("hidden");
      // Ocultar completamente después de la transición
      setTimeout(() => {
        loader.style.display = "none";
      }, 400); // Tiempo de la transición CSS
    }, 100);
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

  //* === MODO OSCURO ===
  try {
    initDarkMode();
  } catch (e) {
    console.warn("Dark mode error:", e);
  }

  //* === CAMBIO DE IDIOMA ===
  try {
    initChangeLanguage();
  } catch (e) {
    console.warn("Change language error:", e);
  }

  //* === CHART.JS: Usuarios por mes ===
  try {
    initChartJsLastMonth();
  } catch (e) {
    console.warn("Chart.js error:", e);
  }

  // * === CAROUSEL DE IMÁGENES ===
  try {
    initCarouselImages();
  } catch (e) {
    console.warn("Carousel error:", e);
  }

  try {
    initOrderItems();
  } catch (e) {
    console.warn("OrderItems error:", e);
  }

  try {
    initChartJsPie();
  } catch (e) {
    console.warn("OrderItems error:", e);
  }

  //* === GSAP ANIMATIONS ===
  try {
    if (typeof gsap !== "undefined") {
      gsap.registerPlugin(ScrollTrigger);
      
      // Limpiar ScrollTriggers previos
      ScrollTrigger.getAll().forEach(trigger => trigger.kill());
      
      // 1. FADE UP - Aparece desde abajo
      const fadeUpElements = document.querySelectorAll(".fade-up");
      fadeUpElements.forEach((element) => {
        gsap.fromTo(element, 
          { y: 70, opacity: 0 },
          {
            scrollTrigger: {
              trigger: element,
              start: "top 85%",
              toggleActions: "play none none none",
            },
            y: 0,
            opacity: 1,
            duration: 1.2,
            ease: "power3.out",
          }
        );
      });

      // 2. FADE LEFT - Aparece desde la derecha
      const fadeLeftElements = document.querySelectorAll(".fade-left");
      fadeLeftElements.forEach((element) => {
        gsap.fromTo(element,
          { x: 100, opacity: 0 },
          {
            scrollTrigger: {
              trigger: element,
              start: "top 85%",
              toggleActions: "play none none none",
            },
            x: 0,
            opacity: 1,
            duration: 1,
            ease: "power2.out",
          }
        );
      });

      // 3. FADE RIGHT - Aparece desde la izquierda
      const fadeRightElements = document.querySelectorAll(".fade-right");
      fadeRightElements.forEach((element) => {
        gsap.fromTo(element,
          { x: -100, opacity: 0 },
          {
            scrollTrigger: {
              trigger: element,
              start: "top 85%",
              toggleActions: "play none none none",
            },
            x: 0,
            opacity: 1,
            duration: 1,
            ease: "power2.out",
          }
        );
      });

      // 4. SCALE UP - Crece desde el centro
      const scaleUpElements = document.querySelectorAll(".scale-up");
      scaleUpElements.forEach((element) => {
        gsap.fromTo(element,
          { scale: 0.7, opacity: 0 },
          {
            scrollTrigger: {
              trigger: element,
              start: "top 85%",
              toggleActions: "play none none none",
            },
            scale: 1,
            opacity: 1,
            duration: 0.8,
            ease: "back.out(1.7)",
          }
        );
      });

      // 5. ROTATE IN - Rota mientras aparece
      const rotateInElements = document.querySelectorAll(".rotate-in");
      rotateInElements.forEach((element) => {
        gsap.fromTo(element,
          { rotation: -15, scale: 0.8, opacity: 0 },
          {
            scrollTrigger: {
              trigger: element,
              start: "top 85%",
              toggleActions: "play none none none",
            },
            rotation: 0,
            scale: 1,
            opacity: 1,
            duration: 1,
            ease: "elastic.out(1, 0.5)",
          }
        );
      });

      // 6. STAGGER - Animación en cadena para hijos
      const staggerContainers = document.querySelectorAll(".stagger-children");
      staggerContainers.forEach((container) => {
        const children = container.children;
        gsap.fromTo(children,
          { y: 50, opacity: 0 },
          {
            scrollTrigger: {
              trigger: container,
              start: "top 85%",
              toggleActions: "play none none none",
            },
            y: 0,
            opacity: 1,
            duration: 0.8,
            stagger: 0.15,
            ease: "power2.out",
          }
        );
      });

      // 7. PARALLAX - Efecto parallax suave
      const parallaxElements = document.querySelectorAll(".parallax");
      parallaxElements.forEach((element) => {
        gsap.to(element, {
          scrollTrigger: {
            trigger: element,
            start: "top bottom",
            end: "bottom top",
            scrub: 1,
          },
          y: -50,
          ease: "none",
        });
      });

      // 8. FADE BLUR - Aparece con desenfoque
      const fadeBlurElements = document.querySelectorAll(".fade-blur");
      fadeBlurElements.forEach((element) => {
        gsap.fromTo(element,
          { opacity: 0, filter: "blur(10px)" },
          {
            scrollTrigger: {
              trigger: element,
              start: "top 85%",
              toggleActions: "play none none none",
            },
            opacity: 1,
            filter: "blur(0px)",
            duration: 1.2,
            ease: "power2.out",
          }
        );
      });
      
      const totalAnimations = fadeUpElements.length + fadeLeftElements.length + 
                              fadeRightElements.length + scaleUpElements.length + 
                              rotateInElements.length + staggerContainers.length + 
                              parallaxElements.length + fadeBlurElements.length;
      
      console.log(`✅ GSAP cargado - ${totalAnimations} elementos con animación`);
    } else {
      console.warn("GSAP no está disponible");
    }
  } catch (e) {
    console.warn("GSAP error:", e);
  }
});
