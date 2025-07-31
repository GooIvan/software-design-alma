export function initChartJsLastMonth() {
  document.querySelectorAll("canvas[id$='Chart']").forEach((chartEl) => {
    const labels = JSON.parse(chartEl.dataset.labels || "[]");
    const values = JSON.parse(chartEl.dataset.values || "[]");
    const label = chartEl.dataset.label || "Datos";
    const color = chartEl.dataset.color || "rgba(54, 162, 235, 0.6)";

    const ctx = chartEl.getContext("2d");

    new Chart(ctx, {
      type: "bar",
      data: {
        labels: labels,
        datasets: [
          {
            label: label,
            data: values,
            backgroundColor: color,
            borderColor: color.replace("0.6", "1"),
            barThickness: 5,
          },
        ],
      },
      options: {
        plugins: {
          legend: { display: false },
          tooltip: {
            enabled: false,
            external: function (context) {
              let tooltipEl = document.getElementById("chartjs-tooltip");
              if (!tooltipEl) {
                tooltipEl = document.createElement("div");
                tooltipEl.id = "chartjs-tooltip";
                tooltipEl.style.cssText = `
                  position: absolute;
                  background: white;
                  border-radius: 4px;
                  padding: 6px 8px;
                  font-size: 0.875rem;
                  color: #333;
                  white-space: nowrap;
                  pointer-events: none;
                  box-shadow: 0 1px 30px rgba(0, 0, 0, 0.1);
                  z-index: 9999;
                  transition: opacity 0.2s ease;
                  opacity: 0;
                `;
                document.body.appendChild(tooltipEl);
              }

              const tooltipModel = context.tooltip;
              if (!tooltipModel || tooltipModel.opacity === 0) {
                tooltipEl.style.opacity = "0";
                return;
              }

              const label = tooltipModel.dataPoints?.[0]?.label || "";
              const value = tooltipModel.dataPoints?.[0]?.formattedValue || "";

              tooltipEl.innerHTML = `
                <div style="text-align: center;">
                  <div style="font-weight: bold;">${label}</div>
                  <br>
                  <div style="display: flex; align-items: center; justify-content: center; gap: 6px;">
                    <span style="
                      display: inline-block;
                      width: 8px;
                      height: 8px;
                      border-radius: 50%;
                      background-color: ${color};">
                    </span>
                    <span class="fw-bold text-dark">${value}</span>
                  </div>
                </div>
              `;

              const canvasRect = context.chart.canvas.getBoundingClientRect();
              const tooltipWidth = tooltipEl.offsetWidth;

              tooltipEl.style.left = `${
                canvasRect.left +
                window.pageXOffset +
                tooltipModel.caretX -
                tooltipWidth / 2
              }px`;
              tooltipEl.style.top = `${
                canvasRect.top + window.pageYOffset + tooltipModel.caretY - 40
              }px`;
              tooltipEl.style.opacity = "1";
            },
          },
        },
        scales: {
          x: { display: false },
          y: { display: false },
        },
      },
    });
  });
}
