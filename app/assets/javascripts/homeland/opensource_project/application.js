window.PostView = Backbone.View.extend({
  el: "body",
  initialize: function(opts) {
    $("<div id='preview' class='markdown form-control' style='display:none;'></div>").insertAfter($('#opensource_project_body'));
    this.hookPreview($(".editor-toolbar"), $(".project-editor"));

    return window._editor = new Editor();
  },
  hookPreview(switcher, textarea) {
    // put div#preview after textarea
    const self = this;
    const preview_box = $(document.createElement("div")).attr("id", "preview");
    preview_box.addClass("markdown form-control");
    $(textarea).after(preview_box);
    preview_box.hide();

    return $(".preview", switcher).click(function () {
      if ($(this).hasClass("active")) {
        $(this).removeClass("active");
        $(preview_box).hide();
        $(textarea).show();
      } else {
        $(this).addClass("active");
        $box = $(preview_box)
        $box.show();
        $(textarea).hide();
        $box.css("height", "auto");
        $box.css("min-height", $(textarea).height());
        self.preview($(textarea).val());
      }
      return false;
    });
  },

  preview(body) {
    $("#preview").text("Loading...");

    return $.post("/opensource_projects/preview",
      { "body": body },
      data => $("#preview").html(data.body),
      "json");
  },
});

document.addEventListener('turbolinks:load', function() {
  return window._postView = new PostView();
});
