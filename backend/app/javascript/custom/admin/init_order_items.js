export function initOrderItems() {
  const container = document.getElementById("order-items-container");
  const addItemBtn = document.getElementById("add-item-btn");
  const template = document.getElementById("order-item-template");

  if (!container || !addItemBtn || !template || !window.categoryToProducts)
    return;

  const categoryToProducts = window.categoryToProducts;
  let itemIndex = 0;

  function isGroupComplete(group) {
    const requiredFields = group.querySelectorAll(
      "select[required], input[required]"
    );
    return Array.from(requiredFields).every(
      (field) => field.value.trim() !== ""
    );
  }

  function updateAddButtonState() {
    const lastGroup = container.querySelector(".order-item-group:last-of-type");
    addItemBtn.disabled = !(lastGroup && isGroupComplete(lastGroup));
  }

  function addEventHandlersToGroup(group) {
    const categorySelect = group.querySelector(".category-select");
    const productSelect = group.querySelector(".product-select");
    const sizeSelect = group.querySelector(".size-select");

    categorySelect.addEventListener("change", () => {
      const catId = categorySelect.value;
      const products = categoryToProducts[catId] || [];

      productSelect.innerHTML =
        `<option value="">Selecciona un producto</option>` +
        products
          .map(
            (p) =>
              `<option value="${p.id}" data-sizes='${JSON.stringify(
                p.sizes
              )}'>${p.name}</option>`
          )
          .join("");

      sizeSelect.innerHTML = `<option value="">Selecciona una talla</option>`;
      updateAddButtonState();
    });

    productSelect.addEventListener("change", () => {
      const selectedOption = productSelect.options[productSelect.selectedIndex];
      const sizes = JSON.parse(selectedOption?.dataset.sizes || "[]");

      sizeSelect.innerHTML =
        `<option value="">Selecciona una talla</option>` +
        sizes
          .map((size) => `<option value="${size}">${size}</option>`)
          .join("");

      updateAddButtonState();
    });

    group.querySelectorAll("select, input").forEach((el) => {
      el.addEventListener("change", updateAddButtonState);
      el.addEventListener("input", updateAddButtonState);
    });
  }

  function addNewGroup() {
    const newHTML = template.innerHTML.replace(/__INDEX__/g, itemIndex++);
    const tempDiv = document.createElement("div");
    tempDiv.innerHTML = newHTML;

    const newGroup = tempDiv.firstElementChild;
    container.appendChild(newGroup);
    addEventHandlersToGroup(newGroup);
    updateAddButtonState();
  }

  container.innerHTML = "";
  itemIndex = 0;
  addNewGroup();

  addItemBtn.addEventListener("click", () => {
    const lastGroup = container.querySelector(".order-item-group:last-of-type");
    if (lastGroup && isGroupComplete(lastGroup)) {
      addNewGroup();
    }
  });
}
