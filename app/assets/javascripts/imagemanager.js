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

				var $box = $('<div id=@quote;redactor-image-manager-box@quote; style=@quote;overflow: auto; height: 300px;@quote; class=@quote;redactor-tab redactor-tab2@quote;>').hide();
				$modal.append($box);

				var csrfMeta = document.querySelector('meta[name=@quote;csrf-token@quote;]');
				var csrfToken = csrfMeta && csrfMeta.getAttribute('content');
				var authenticityToken = $('<input type=@quote;hidden@quote; id=@quote;image_upload_auth_token@quote; name=@quote;request_forgery_protection_token@quote; value=@quote;' + csrfToken + '@quote; >');
				$modal.append(authenticityToken);

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

							var img = $('<img src=@quote;' + val.thumb + '@quote; rel=@quote;' + val.image + '@quote; image_id=@quote;' + val.unique_id + '@quote;title=@quote;' + thumbtitle + '@quote; style=@quote;width: 100px; height: 75px; cursor: pointer;@quote; />');
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
