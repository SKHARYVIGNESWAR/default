//$Id$
package  com.adventnet.crm.tpi.ctiapi.actions;
//skjdbv
import java.util.logging.Level;
import java.util.logging.Logger;

import org.json.JSONObject;

import com.adventnet.crm.common.actions.CrmActionSupport;
import com.adventnet.crm.common.util.CrmConstants;
import com.adventnet.crm.common.util.RebrandLinkUtil;
import com.adventnet.crm.tpi.ctiapi.util.CtiApiUtil;

public class TwilioSIPConfigAction extends CrmActionSupport
{
	private static final Logger LOGGER = Logger.getLogger(TwilioSIPConfigAction.class.getName());

	public String execute()
	{
		String responseStr = "";
		try
		{
			String zgid = request.getAttribute(CrmConstants.ZGID_FROM_FILTER)+"";
			String zuid = request.getAttribute(CrmConstants.ZUID_FROM_REQUEST)+"";

			String twiSipZgid = zgid;
			String twiSipZuid = zuid;

			if( twiSipZgid.equals(zgid) && twiSipZuid.equals(zuid) )
			{
				String event = request.getParameter("event");
				JSONObject sipConfObj = CtiApiUtil.retrieveSIPConfigInfoFromRedis(zgid);

				if( "add".equals(event) )
				{
					String enableSip = request.getParameter("enableSip");
					String sipUsername = request.getParameter("sipUsername");
					String sipPassword = request.getParameter("sipPassword");
					String domain = request.getParameter("sipDomain");
					String callRatePrefix = request.getParameter("sipCallrate");

					sipConfObj.put("enablesip", enableSip);
					sipConfObj.put("sipusername", sipUsername);
					sipConfObj.put("sippassword", sipPassword);
					sipConfObj.put("sipdomain", domain);
					sipConfObj.put("sipcallrateprefix", callRatePrefix);

					CtiApiUtil.storeSIPConfigContentIntoZFS(zgid, sipConfObj.toString());
					CtiApiUtil.addSIPConfigInfoInRedis(zgid, sipConfObj.toString());
					return null;
				}
				else
				{
					request.setAttribute("sipConfObj", sipConfObj.toString());
					responseStr = "twilioSipConfig";//No i18n
				}
			}
			else
			{
				responseStr = "onError";//No i18n
			}
		}
		catch(Exception e)
		{
			LOGGER.log(Level.INFO,"Exception while Twilio Sip Configuration");
			responseStr = "onError";//No i18n
		}
		return responseStr;
	}
}
