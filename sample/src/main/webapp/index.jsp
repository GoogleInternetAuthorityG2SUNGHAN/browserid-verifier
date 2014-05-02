<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
	<head>
		<title>Sample</title>
		<script type="text/javascript"
			src="http://code.jquery.com/jquery-2.0.2.min.js"></script>
		<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,800'
			rel='stylesheet'>
		<style>
			h1 { font-size: 8vw; }
			h3 { font-size: 2vw; }
			h4 { font-size: 1vw; }

			@media ( max-width : 800px) {
				aside,section {
					width: auto;
					float: none;
				}
			}
		</style>
	</head>

	<body>
		<h3>
		Login using <a href="http://www.mozilla.org/en-US/persona">Mozilla
			Persona</a> a Browser ID implementation
		</h3>

		Welcome: ${sessionScope.email}
		<br>
		<c:choose>
			<c:when test="${empty sessionScope.email}">
				<input type="image" src="persona-only-signin-link.png" name="image"
					onclick="navigator.id.request();">
	
	
	            <br />
	            <br />  
				<h3>
					<a href="https://github.com/user454322/browserid-verifier">
						Simple Java BrowserID Verifier </a>
				</h3>
			</c:when>
			<c:otherwise>
	        	<button type="button" onclick="navigator.id.logout();">Sign out</button>        	
	    	</c:otherwise>
		</c:choose>
	
	
	
		<script src="https://login.persona.org/include.js"></script>
	
		<script type="text/javascript">
			var currentUser = '${sessionScope.email}';
	
			navigator.id.watch({
				loggedInUser : currentUser,
				onlogin : function(assertion) {
					// A user has logged in! Here you need to:
					// 1. Send the assertion to your backend for verification and 
					//		to create a session.
					// 2. Update your UI.
					loginRequest = $.ajax({
						type : 'POST',
						url : 'in', // This is a URL on your website.
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
					// A user has logged out! Here you need to:
					// Tear down the user's session by redirecting the user or 
					//		making a call to your backend.
					// Also, make sure loggedInUser will get set to null on the 
					//		next page load.
					// (That's a literal JavaScript null. 
					//		Not false, 0, or undefined. null.)
					logoutRequest = $.ajax({
						type : 'POST',
						url : 'out' // This is a URL on your website.	      
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