(function($)
{
	$.Redactor.prototype.imagemanager = function()
	{
		return {
			langs: {
				en: {
					'upload': 'Upload',
					'choose': 'Choose'
				}
			},
			init: function()
			{
				if (!this.opts.imageManagerJson)
				{
					return;
				}

				this.modal.addCallback('image', this.imagemanager.load);
			},
			load: function()
			{
				var $modal = this.modal.getModal();

				this.modal.createTabber($modal);
				this.modal.addTab(1, this.lang.get('upload'), 'active');
				this.modal.addTab(2, this.lang.get('choose'));

				$('#redactor-modal-image-droparea').addClass('redactor-tab redactor-tab1');

				var $box = $('<div id="redactor-image-manager-box" style="overflow: auto; height: 300px;" class="redactor-tab redactor-tab2">').hide();
				$modal.append($box);

				var csrfMeta = document.querySelector('meta[name="csrf-token"]');
				var csrfToken = csrfMeta && csrfMeta.getAttribute('content');
				var authenticityToken = $('<input type="hidden" id="image_upload_auth_token" name="request_forgery_protection_token" value="' + csrfToken + '" >');
				$modal.append(authenticityToken);

				$.ajax({
					dataType: 'json',
					cache: false,
					url: this.opts.imageManagerJson,
					success: $.proxy(function(collection)
					{
						$.each(collection.items, $.proxy(function(key, val)
						{
							// title
							var thumbtitle = '';
							if (typeof val.name !== 'undefined')
							{
								thumbtitle = val.name;
							}

							var image = val.image;
							if (typeof image == 'object')
							{
								var img = $('<img src="' + image['thumbnail/small']['contentUrl'] + '" rel="' + image['thumbnail/medium']['contentUrl'] + '" item_id="' + val.id + '"title="' + thumbtitle + '" style="width: 100px; height: 75px; cursor: pointer;" />');
								$('#redactor-image-manager-box').append(img);
								$(img).click($.proxy(this.imagemanager.insert, this));
							}
						}, this));
					}, this)
				});


			},
			insert: function(e)
			{
				var style = 'width: 300px; height: auto; float: left; margin: 0px 10px 10px 0px;';
				var $el = $(e.target);
				var img = document.createElement('img');
				img.src = $el.attr('rel');
				img.alt = $el.attr('title');
				img.title = $el.attr('title');
				img.setAttribute('style', style);
				img.setAttribute('rel', style);
				img.setAttribute('class', 'hc_page_image');
				img.setAttribute('item_id', $el.attr('item_id'));

				var figCap = document.createElement('figcaption');
				figCap.innerHTML = "Image caption";

				var fig = document.createElement('figure');
				fig.setAttribute('style', style);
				fig.setAttribute('rel', style);

				fig.appendChild(img);
				fig.appendChild(figCap);

				this.insert.node(fig);
				this.observe.images();
				this.modal.close();
			}
		};
	};
})(jQuery);
