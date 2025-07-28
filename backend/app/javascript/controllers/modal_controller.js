import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["container", "content"];

  connect() {
    if (!sessionStorage.getItem("modalShown")) {
      this.containerTarget.style.display = "flex";
    }
  }

  close() {
    this.containerTarget.style.display = "none";
    sessionStorage.setItem("modalShown", "true");
  }

  backgroundClose(event) {
    // Si se hace clic en el fondo, cierra
    if (event.target === this.containerTarget) {
      this.close();
    }
  }

  stopPropagation(event) {
    // Prevenir que el clic dentro del modal cierre el fondo
    event.stopPropagation();
  }
}
