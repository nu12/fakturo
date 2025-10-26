import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "placeholder" ]
  connect() {}
  renderForm(e){
    const id = e.params.id;
    var formPlaceholder = this.placeholderTarget;
    fetch("/expenses/renderform/" + id).then(response => response.text()).then(data => formPlaceholder.innerHTML = data);
  }
}

