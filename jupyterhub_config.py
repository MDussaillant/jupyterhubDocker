import os
from pwd import getpwnam
print('Init config jupyterHub *******************************************************')
c.Authenticator.admin_users = {'adminjh'}
c.LocalAuthenticator.create_system_users=True
c.DummyAuthenticator.password = "toto"

# LDAP
#c.JupyterHub.authenticator_class = 'ldapauthenticator.LDAPAuthenticator'
#c.LDAPAuthenticator.server_address = 'ldap.forumsys.com:389'
#c.LDAPAuthenticator.bind_dn_template = "uid={username},dc=example,dc=com"
#c.LDAPAuthenticator.use_ssl = False
#c.LDAPAuthenticator.lookup_dn_search_user = "ou=People,dc=allende,dc=lyc14,dc=ac-caen,dc=fr")

def my_hook(spawner):
    username = spawner.user.name
    #os.system("useradd "+username)
    path = "/home/"+username
    print('Spawner *******************************************************')
    try:
        print('Mkdir *******************************************************')
        os.mkdir(path)
    except OSError:
        print ("Creation of the directory %s failed" % path)
    else:
        print ("Successfully created the directory %s " % path)
        os.chown(path, getpwnam(username)[2],getpwnam(username)[3] )
        os.chmod(path,0o700)

c.Spawner.pre_spawn_hook = my_hook
c.Spawner.default_url = 'lab/tree/home/{username}'
c.Spawner.notebook_dir = '/'
print('Fin *******************************************************')