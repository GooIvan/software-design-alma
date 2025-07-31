export function initChartJsPie() {
  document.querySelectorAll("canvas[data-chart-type='pie']").forEach((chartEl) => {
    const safeParse = (data) => {
      try {
        return JSON.parse(data || "[]");
      } catch (error) {
        console.warn("Error al parsear JSON:", error);
        return [];
      }
    };

    const labels = safeParse(chartEl.dataset.labels);
    const values = safeParse(chartEl.dataset.values);
    const label = chartEl.dataset.label || "Datos";
    const colors = safeParse(chartEl.dataset.colors);

    if (!Array.isArray(labels) || !Array.isArray(values) || labels.length === 0 || values.length === 0) {
      console.warn("Gráfico no generado: datos inválidos.");
      return;
    }

    const ctx = chartEl.getContext("2d");

    // 💥 DESTRUIR gráfico anterior si ya existe
    const existingChart = Chart.getChart(chartEl);
    if (existingChart) {
      existingChart.destroy();
    }

    new Chart(ctx, {
      type: "pie", // 🍩 GRÁFICO DE TORTA
      data: {
        labels: labels,
        datasets: [
          {
            label: label,
            data: values,
            backgroundColor: colors.length ? colors : generateRandomColors(values.length),
            borderWidth: 1,
          },
        ],
      },
      options: {
        responsive: true,
        plugins: {
          legend: {
            position: "right",
          },
          tooltip: {
            enabled: true,
            callbacks: {
              label: function (context) {
                const label = context.label || "";
                const value = context.parsed || 0;
                return `${label}: ${value}`;
              },
            },
          },
        },
      },
    });
  });
}

function generateRandomColors(count) {
  const colors = [];
  for (let i = 0; i < count; i++) {
    const r = Math.floor(Math.random() * 200);
    const g = Math.floor(Math.random() * 200);
    const b = Math.floor(Math.random() * 200);
    colors.push(`rgba(${r}, ${g}, ${b}, 0.7)`);
  }
  return colors;
}
