window.ShortUrl = Backbone.Model.extend({
	defautls:{
		target: null		
	}
})

window.ShortUrlList = Backbone.Collection.extend({
	model: ShortUrl
})

window.IndexView = Backbone.View.extend({
	el: '.content',

	events:{
		'click a.add' : 'add'
	},

	initialize(){
		this.collection = new ShortUrlList(gon.short_urls);
		new ShortUrlListView({collection: this.collection});

	},

	add(){		
		let form = this.$el.find('form')[0]
		if(form.checkValidity()){
			let target = this.$el.find('input[name=new_target]').val();		
			let self = this;
			$.ajax({
				url: '/welcome',
				type: 'post',
				data: {target: target},
				async: false,
		    headers: {
		      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
		    },				
		    success: function(short_url){
		    	let _short_url = new ShortUrl(short_url);
					self.collection.add(_short_url);
		    }
			});				
		}else{
			$(form).addClass('was-validated');
		}

	}
})

window.ShortUrlListView = Backbone.View.extend({
	el: '.list',

	initialize(){
		this.listenTo(this.collection, 'add', this.listAll)
		this.listAll();
	},

	listAll(){
		let self = this;
		self.$el.empty();
		_.each(this.collection.models, function(model){
			let url_view = new ShortUrlView({model: model});
			self.$el.append(url_view.el);
		})
	}
})

window.ShortUrlView = Backbone.View.extend({
	initialize(){
		this.render();
	},

	render(){
		let source = $("#urlView").html();
		let dom = Handlebars.compile(source)(this.model.attributes);
		this.$el.html(dom);
		this.$el.addClass('form-group')
		this		
	}
})


$(function(){
	new IndexView();
})