import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    containerId: String
  }

  connect() {
    console.log('Connected')
    this.scrollToBottom()
    this.observer = new MutationObserver(this.scrollToBottom.bind(this));
    this.observer.observe(this.element, { attributes: false, childList: true, subtree: true });
  }

  disconnect() {
    this.observer.disconnect();
  }

  scrollToBottom() {
    const container = document.getElementById(this.containerIdValue)
    container.scrollTop = container.scrollHeight
  }
}
