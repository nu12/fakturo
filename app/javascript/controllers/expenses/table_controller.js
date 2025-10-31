import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "categories", "category", "subcategory","placeholder", "control", "expense" ]
  connect() {}
  renderForm(e){
    const id = e.params.id;
    var formPlaceholder = this.placeholderTarget;
    fetch("/expenses/renderform/" + id).then(response => response.text()).then(data => formPlaceholder.innerHTML = data);
  }
  changeAll(){
    var control = this.controlTarget;
    this.expenseTargets.forEach(element => {
      element.checked = control.checked
      //console.log(element.getAttribute("data-id"))
    });
  }
  getSelectedSubcategories(){
    var selected = []
    this.expenseTargets.forEach(element => {
      if (element.checked) {
        selected.push(element.getAttribute("data-id"))
      }
    });
    document.getElementById("selected").value = selected.join()
  }
  selectSubcategories(){
    const element = this.categoriesTarget;
    const categories = JSON.parse(element.value);
    var category_id = this.categoryTarget.value;
    var selector = this.subcategoryTarget;
    var filter = categories.filter((c) => c.id == category_id)
    
    if (filter.length < 1) {selector.innerHTML = "<option value=\"\">Select a category</option>";}
    else{
      var subcategories = filter[0].subcategories;
      selector.innerHTML = "";
      subcategories.forEach((s) =>  selector.innerHTML += "<option value=" + s.id + ">" + s.name + "</option>");
    }
  }
}

