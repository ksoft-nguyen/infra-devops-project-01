import hudson.model.User
import hudson.security.FullControlOnceLoggedInAuthorizationStrategy
import hudson.security.HudsonPrivateSecurityRealm
import jenkins.install.InstallState
import jenkins.model.Jenkins
import jenkins.model.JenkinsLocationConfiguration

def jenkins = Jenkins.get()
def adminId = System.getenv('JENKINS_ADMIN_ID') ?: 'admin'
def adminPassword = System.getenv('JENKINS_ADMIN_PASSWORD') ?: 'admin123'

def realm = jenkins.getSecurityRealm()
if (!(realm instanceof HudsonPrivateSecurityRealm)) {
  realm = new HudsonPrivateSecurityRealm(false)
  jenkins.setSecurityRealm(realm)
}

if (realm.getUser(adminId) == null) {
  realm.createAccount(adminId, adminPassword)
} else {
  def user = User.getById(adminId, false)
  if (user != null) {
    user.addProperty(HudsonPrivateSecurityRealm.Details.fromPlainPassword(adminPassword))
    user.save()
  }
}

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
jenkins.setAuthorizationStrategy(strategy)

def locationUrl = System.getenv('JENKINS_URL')
if (locationUrl) {
  def location = JenkinsLocationConfiguration.get()
  location.setUrl(locationUrl)
  location.save()
}

jenkins.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)
jenkins.save()
