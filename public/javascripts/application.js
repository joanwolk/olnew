// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){
	$('a.quick-reply').click(function(e){
		e.preventDefault();
		var m = /\?reply=(\d*)&thread=(\d*)/.exec($(this).attr('href'));
		var name = /^\w+/.exec($(this).parent().html())[0];
		console.log(m);
		var form = $("#quickmessage");
		form.find('input[name=reply]').val(m[1]);
		form.find('input[name=thread]').val(m[2]);
		var msg = form.find('input[name=text]');
		var text = msg.val();
		if (/^@\w+/.test(text)) text = text.replace(/^@\w+/, '@'+name);
		else text = '@'+name+' '+text;
		msg.val(text).focus();
		console.log(form);
		return false;
	});
});

