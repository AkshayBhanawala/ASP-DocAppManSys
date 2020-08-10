$(document).ready(function () {

	var animDuration = 500;
	
	$('a').bind('click', function () {
		// When AnchorTag is Used as Link
		// Use "aria-valuetext=submit" attribute to define AnchorTag's Button/Submit Behaviour

		var X = $(this).attr('aria-valuetext');
		if (X != 'submit' || X != 'button') {
			var href = $(this).attr('href');

			$('body').addClass('UnloadSplashScreen');

			setTimeout(function () {
				window.location = href;
			}, animDuration);
			return false; // prevent user navigation away until animation's finished
		}
	});
});