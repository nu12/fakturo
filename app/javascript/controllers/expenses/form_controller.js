import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "categories", "category", "subcategory", "form" ]
  connect() {}
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
}

