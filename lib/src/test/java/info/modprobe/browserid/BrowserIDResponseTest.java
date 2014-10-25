/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. 
 */

package info.modprobe.browserid;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import info.modprobe.browserid.BrowserIDResponse.Status;

import java.util.Date;

import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;

public class BrowserIDResponseTest {

	private static final String AUDIENCE = "https://example.com";
	private static final String EMAIL = "bob@mail.com";
	private static final long EXPIRES = 1223334444150L;
	private static final String INVALID_STATUS = "invStatu";
	private static final String ISSUER = "login.persona.org";
	private static final String REASON = "assertion has expired";

	private static final String INVALID_JSON_RESPONSE = "\"status\":\"failure\",\"reason\":\"assertion has expired\"";
	private static final String FAILURE_RESPONSE = "{\"status\":\"failure\",\"reason\":\"assertion has expired\"}";
	private static final String INVALID_STATUS_RESPONSE = String
			.format("{\"audience\":\"%s\",\"expires\":1223334444150,\"issuer\":\"login.persona.org\", \"email\":\"bob@mail.com\",\"status\":\"%s\"}",
					AUDIENCE, INVALID_STATUS);
	private static final String MIXED_RESPONSE = String.format("{\"audience\":\"%s\",\"expires\":1223334444150,\"issuer\":\"login.persona.org\", \"email\":\"bob@mail.com\",\"status\":\"failure\",\"status\":\"okay\"}", AUDIENCE);
	private static final String NO_STATUS_RESPONSE = String.format("{\"audience\":\"%s\",\"expires\":1223334444150,\"issuer\":\"login.persona.org\", \"email\":\"bob@mail.com\"}", AUDIENCE);
	private static final String NO_EXPIRES_RESPONSE = String.format("{\"audience\":\"%s\",\"issuer\":\"login.persona.org\", \"email\":\"bob@mail.com\",\"status\":\"okay\"}", AUDIENCE);
	private static final String OKAY_RESPONSE = String.format("{\"audience\":\"%s\",\"expires\":1223334444150,\"issuer\":\"login.persona.org\", \"email\":\"bob@mail.com\",\"status\":\"okay\"}", AUDIENCE);
	private static final String WRONG_AUDIENCE_TYPE_RESPONSE = "{\"audience\":true,\"expires\":1223334444150,\"issuer\":\"login.persona.org\", \"email\":\"bob@mail.com\",\"status\":\"okay\"}";

	@Rule
	public final ExpectedException expectedException = ExpectedException.none();	

	@Test
	public void failureResponse() {
		final BrowserIDResponse fail = new BrowserIDResponse(FAILURE_RESPONSE);
		assertEquals(Status.FAILURE, fail.getStatus());
		assertNull(fail.getAudience());
		assertNull(fail.getEmail());
		assertNull(fail.getExpires());
		assertNull(fail.getIssuer());
		assertEquals(REASON, fail.getReason());
	}

	@Test
	public void invalidResponse() {
		expectedException.expect(BrowserIDException.class);
		new BrowserIDResponse(INVALID_JSON_RESPONSE);
	}

	@Test
	public void invalidStatus() {
		expectedException.expect(BrowserIDException.class);
		expectedException.expectMessage(String.format("Invalid status '%s'",
				INVALID_STATUS));
		BrowserIDResponse browserIDResponse = new BrowserIDResponse(
				INVALID_STATUS_RESPONSE);
		browserIDResponse.getStatus();
	}

	@Test
	public void noStatusResponse() {
		expectedException.expect(BrowserIDException.class);
		new BrowserIDResponse(NO_STATUS_RESPONSE);
	}

	@Test
	public void mixedResponse() {
		expectedException.expect(BrowserIDException.class);
		expectedException.expectMessage("Invalid JSON");
		new BrowserIDResponse(MIXED_RESPONSE);
	}
	
	
		
		
	@Test
	public void okayResponse() {
		final BrowserIDResponse ok = new BrowserIDResponse(OKAY_RESPONSE);
		assertEquals(Status.OK, ok.getStatus());
		assertEquals(AUDIENCE, ok.getAudience());
		assertEquals(EMAIL, ok.getEmail());
		assertEquals(new Date(EXPIRES), ok.getExpires());
		assertEquals(ISSUER, ok.getIssuer());
		assertNull(ok.getReason());
	}

	@Test
	public void responseWithoutExpires() {
		final BrowserIDResponse expires = new BrowserIDResponse(
				NO_EXPIRES_RESPONSE);
		assertEquals(Status.OK, expires.getStatus());
		assertEquals(AUDIENCE, expires.getAudience());
		assertEquals(EMAIL, expires.getEmail());
		assertNull(expires.getExpires());
		assertEquals(ISSUER, expires.getIssuer());
		assertNull(expires.getReason());
	}

	@Test
	public void wrongAudienceTypeResponse() {
		expectedException.expect(BrowserIDException.class);		
		new BrowserIDResponse(WRONG_AUDIENCE_TYPE_RESPONSE);
	}

}