import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "spinner" ]
  connect() {
    // console.log("connectado")
    this.spinnerTarget.classList.remove("d-block")
  }
  showLoader() {
    this.spinnerTarget.classList.add("d-block")
  }
}
