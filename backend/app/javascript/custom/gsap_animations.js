document.addEventListener("turbo:load", () => {
  // Asegurar que GSAP cargó
  if (typeof gsap === "undefined") {
    console.error("GSAP no está cargado");
    return;
  }

  gsap.registerPlugin(ScrollTrigger);

  // Limpiar ScrollTriggers previos para evitar duplicados con Turbo
  ScrollTrigger.getAll().forEach(trigger => trigger.kill());

  // Aplicar animación a TODOS los elementos con clase .fade-up
  const fadeUpElements = document.querySelectorAll(".fade-up");
  
  fadeUpElements.forEach((element) => {
    gsap.fromTo(element, 
      {
        y: 70,
        opacity: 0
      },
      {
        scrollTrigger: {
          trigger: element,
          start: "top 85%",
          end: "bottom 20%",
          toggleActions: "play none none none",
          // markers: true, // Descomenta esto para debug
        },
        y: 0,
        opacity: 1,
        duration: 1.2,
        ease: "power3.out",
      }
    );
  });

  console.log(`✅ GSAP cargado - ${fadeUpElements.length} elementos con animación`);
});
