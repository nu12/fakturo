import { Controller } from "@hotwired/stimulus"

// The expenses controller is connected either in the expenses/new page or when a page render expenses_table
export default class extends Controller {
  static targets = [ "form", "expense" ]
  connect() {}

  // This function can be called to change the subcategoty selector either in the _form or _table partials
  updateSubcategorySelector(e){
    const categories = JSON.parse(document.getElementById("categoriesForCurrentUser").value);
    var category_id = e.target.value;
    var subcategorySelectors = document.getElementsByClassName("subcategorySelector");
    var filter = categories.filter((c) => c.id == category_id)
    
    if (filter.length < 1)
      return
    
    var subcategories = filter[0].subcategories;
    var optionsHTML = ""
    subcategories.forEach((s) => optionsHTML += "<option value=" + s.id + ">" + s.name + "</option>");
    console.log(optionsHTML);
    Array.from(subcategorySelectors).forEach((s) => s.innerHTML = optionsHTML);
  }
  renderForm(e){
    const id = e.params.id;
    var formPlaceholder = document.getElementById("formPlaceholder")
    fetch("/expenses/" + id + "/edit").then(response => response.text()).then(data => formPlaceholder.innerHTML = data);
  }
  sendForm() {
    const csrf = document.querySelector('meta[name=csrf-token]').content;
    const f = this.formTarget;
    var data = new URLSearchParams();
    
    for (const pair of new FormData(f)) {
      data.append(pair[0], pair[1]);
    }
    fetch(f.action + ".json", {
      method: 'post',
      body: data,
      headers: {"X-CSRF-Token": csrf},
    }).then(setTimeout(function() {location.reload()}, 100));
  }
  deleteExpense() {
    const csrf = document.querySelector('meta[name=csrf-token]').content;
    const f = this.formTarget;
    fetch(f.action + ".json", {
      method: 'delete',
      headers: {"X-CSRF-Token": csrf},
    }).then(setTimeout(function() {location.reload()}, 100));
  }
  
  // When the checkbox are visible, toogle all checkboxes
  changeAll(e){
    this.expenseTargets.forEach(element => {
      element.checked = e.target.checked
    });
  }

  // Get values from selected checkbozes
  getSelectedSubcategories(){
    var selected = []
    this.expenseTargets.forEach(element => {
      if (element.checked) {
        selected.push(element.getAttribute("data-id"))
      }
    });
    document.getElementById("selected").value = selected.join()
  }
}

