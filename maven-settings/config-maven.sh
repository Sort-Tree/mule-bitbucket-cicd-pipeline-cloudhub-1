#!/bin/bash

# Get access token for connected app
echo "Calling Anypoint API to get access token for connected app..."
API_RESPONSE=$(curl --location --request POST "https://anypoint.mulesoft.com/accounts/api/v2/oauth2/token" \
--header "Content-Type: application/x-www-form-urlencoded" \
--data-urlencode "client_id=${CA_ROOT_EXCHANGE_ADMIN_CLIENT_ID}" \
--data-urlencode "client_secret=${CA_ROOT_EXCHANGE_ADMIN_CLIENT_SECRET}" \
--data-urlencode "grant_type=client_credentials")

if [[ $? -eq 0 ]]; then
	echo "Access token returned - OK"
else
  echo "ERROR: Call to Aypoint API failed. Exiting..."
	exit 1
fi

# Parse access token from response JSON
ACCESS_TOKEN=$(echo $API_RESPONSE | sed -e 's/{"access_token":"\(.*\)","expires_in.*/\1/')

# Add server entries to settings.xml
sed -i~ "/<servers>/ a\
<server>\
  <id>mulesoft-releases</id>\
  <username>${MAVEN_NEXUS_USERNAME}</username>\
  <password>${MAVEN_NEXUS_PASSWORD}</password>\
</server>\
<server>\
  <id>MuleRepository</id>\
  <username>${MAVEN_NEXUS_USERNAME}</username>\
  <password>${MAVEN_NEXUS_PASSWORD}</password>\
</server>\
<server>\
  <id>anypoint-exchange-v2-org1</id>\
  <username>~~~Token~~~</username>\
  <password>${ACCESS_TOKEN}</password>\
</server>\
<server>\
  <id>anypoint-exchange-v2-org2</id>\
  <username>~~~Token~~~</username>\
  <password>${ACCESS_TOKEN}</password>\
</server>" /usr/share/maven/conf/settings.xml

# Add profile to settings.xml including repository entries
sed -i "/<profiles>/ a\
<profile>\
	<id>Mule</id>\
	<activation>\
		<activeByDefault>true</activeByDefault>\
	</activation>\
	<repositories>\
		<repository>\
			<id>MuleRepository</id>\
			<name>MuleRepository</name>\
			<url>https://repository.mulesoft.org/nexus-ee/content/repositories/releases-ee/</url>\
			<layout>default</layout>\
			<releases>\
				<enabled>true</enabled>\
			</releases>\
			<snapshots>\
				<enabled>true</enabled>\
			</snapshots>\
		</repository>\
		<repository>\
			<id>mulesoft-releases</id>\
			<name>MuleSoft Repository</name>\
			<url>http://repository.mulesoft.org/releases/</url>\
			<layout>default</layout>\
		</repository>\
		<repository>\
			<id>mulesoft-public</id>\
			<name>MuleSoft Public Repository</name>\
			<url>https://repository.mulesoft.org/nexus/content/repositories/public/</url>\
			<layout>default</layout>\
		</repository>\
		<repository>\
			<id>mulesoft-snapshots</id>\
			<name>MuleSoft Snapshot Repository</name>\
			<url>http://repository.mulesoft.org/snapshots/</url>\
			<layout>default</layout>\
		</repository>\
    <repository>\
      <id>anypoint-exchange-v2</id>\
      <name>Exchange Repository</name>\
      <url>https://maven.anypoint.mulesoft.com/api/v2/organizations/${BUS_GROUP_ID_ORG1}/maven</url>\
      <layout>default</layout>\
    </repository>\
	</repositories>\
</profile>" /usr/share/maven/conf/settings.xml
