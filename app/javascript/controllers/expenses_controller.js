import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "categories", "category", "subcategory" ]
  connect() {}
  select_subcategories(){
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

