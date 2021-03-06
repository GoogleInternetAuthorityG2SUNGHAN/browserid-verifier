<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
	<head>
		<title>Sample</title>
		<link rel="icon" href="favicon.ico" type="image/x-icon">
		<script type="text/javascript"
			src='https://code.jquery.com/jquery-2.0.2.min.js'></script>
		<link href='https://fonts.googleapis.com/css?family=Open+Sans:400,800' 
			rel='stylesheet'>
		<style>
			h3 { font-size: 2vw; }
			h4 { font-size: 1.5vw; }
			h5 { font-size: 1.2vw; }
		</style>
	</head>

	<body bgcolor=#FFECA3>
		<h3>&quot;Sing in / Sign up&quot; using <a href="http://www.mozilla.org/en-US/persona">Mozilla Persona</a></h3>

		<h5>Welcome ${sessionScope.email}</h5>
		<br>
		<c:choose>
			<c:when test="${empty sessionScope.email}">
				<input id="persona_sign_in_up" type="image" src="persona-only-signin-link.png" 
					onclick="navigator.id.request({siteName:&quot;Sample&quot;,backgroundColor:&quot;#FFECA3&quot;,siteLogo:&quot;/images/sample_logo.png&quot;});">
					<!-- See https://developer.mozilla.org/en-US/docs/Web/API/navigator.id.request -->
			</c:when>
			<c:otherwise>
			<button id="sign_out" type="button" onclick="navigator.id.logout();">Sign out</button>
	    	</c:otherwise>
		</c:choose>

	    <br />
		<h4>
			<a href="https://github.com/user454322/browserid-verifier">
				Simple Java BrowserID Verifier 
			</a>
		</h4>
	
	
		<script src="https://login.persona.org/include.js"></script>

		<script type="text/javascript">
			var currentUser = '${sessionScope.email}';
			if(!currentUser){
				// If falsy set it to the literal null
				currentUser = null;
			}

			navigator.id.watch({
				loggedInUser : currentUser,
				onlogin : function(assertion) {
					loginRequest = $.ajax({
						type : 'POST',
						url : 'in',
						data : {
							assertion : assertion
						}
					});
					loginRequest.done(function(res, status, xhr) {
						window.location.reload();
					});
					loginRequest.fail(function(xhr, status, error) {
						navigator.id.logout();
						alert("Login error: " + error);
					});
				},

				onlogout : function() {
					logoutRequest = $.ajax({
						type : 'POST',
						url : 'out'	      
					});
					logoutRequest.done(function(res, status, xhr) {
						window.location.reload();
					});
					logoutRequest.fail(function(xhr, status, error) {
						alert("Logout error: " + error);
					});
				}

			});
		</script>


	</body>
</html>

