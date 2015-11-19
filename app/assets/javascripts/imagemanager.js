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

				var csrf_meta = document.querySelector('meta[name="csrf-token"]');
				var csrf_token = csrf_meta && csrf_meta.getAttribute('content');
				var $authenticity_token = $('<input type="hidden" id="image_upload_auth_token" name="request_forgery_protection_token" value="' + csrf_token + '" >');
				$modal.append($authenticity_token);

				$.ajax({
					dataType: 'json',
					cache: false,
					url: this.opts.imageManagerJson,
					success: $.proxy(function(data)
					{
						$.each(data, $.proxy(function(key, val)
						{
							// title
							var thumbtitle = '';
							if (typeof val.title !== 'undefined')
							{
								thumbtitle = val.title;
							}

							var img = $('<img src="' + val.thumb + '" rel="' + val.image + '" image_id="' + val.unique_id + '"title="' + thumbtitle + '" style="width: 100px; height: 75px; cursor: pointer;" />');
							$('#redactor-image-manager-box').append(img);
							$(img).click($.proxy(this.imagemanager.insert, this));

						}, this));

					}, this)
				});


			},
			insert: function(e)
			{
				var $el = $(e.target);

				var img = document.createElement('img');
				img.src = $el.attr('rel');
				img.alt = $el.attr('title');
				img.title = $el.attr('title');
				img.style.width = '300px';
				img.style.height = 'auto';
				img.setAttribute('style', 'width: 300px; height: auto; float: left; margin: 0px 10px 10px 0px;');
				img.setAttribute('rel', 'width: 300px; height: auto; float: left; margin: 0px 10px 10px 0px;');

				this.insert.node(img);
				this.observe.images();
				this.modal.close();
			}
		};
	};
})(jQuery);
