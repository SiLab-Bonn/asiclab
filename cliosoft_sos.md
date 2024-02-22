Each site has a cache server, and the main site will have a primary server.

SOS can be managed via `sosadmin`

```
    'sosadmin' without any arguments will invoke the GUI
    interface.

    'sosadmin' with command line arguments will execute in
    command line mode.

    Help for command line interface follows.

ARGUMENTS
    command name
        The first argument must be a command name.
        The commands currently supported are:

            archive        - Archives project data.
            audit          - show the audit trail for the project.
            cachecleanup   - Cleanup the cache data of a project.
            clients        - List clients connected to the server.
            create         - Create a new server.
            createproject  - Create a new project.
      	    debug          - Log debug messages to the server.
            delete         - Deletes a server.
            deleteproject  - Deletes a project.
            exitclients    - Exit clients connected to the server or a given project.
            getcfg         - Get customized cfg file.
            listconsumers  - Prints all consumers of the references in a given project. 
            help           - Print help.
            info           - Get configuration information about a server.
            list           - List defined servers.
            lockproject    - Lock a project.
            ping           - Test if the server is running.
            pingall        - Test if all the servers are running.
            projectmap     - Add / Delete / View project mapping.
            projects       - List projects managed by the server.
            putcfg         - Put customized cfg file.
            query          - Get project information such as list of labels.
            readcfg        - Re-read server configuration files.
            reimport       - Incrementally reimport an sos6 project.
            restore        - Restores project data from archive.
            shell          - Have server run a program or script.
            showdiffs      - Generate a report between 2 RSO's.
            showlabels     - Show all objects in project matching the label.
            shutdown       - Shutdown the server.
            sos6reposanity - Sanity check the sos6 project repository.
            startup        - Start the server.
            
        For more information on any command type:
            sosadmin help <command name>
```



```
** IMPORTANT NOTE: sosadmin has been replaced by SOS Manager (sosmgr)
   SOS Manager is an enterprise-class replacement for sosadmin.
   It provides a web-based interface to manage and monitor
   SOS services at all sites irrespective of which release of SOS
   is being used for each service.

   This has a few implications:
     -  A web server will run and listen to an admin specified port
     -  The installation path cannot be moved once completed
     -  The SOS Manager web server & SOS service daemons will all be run
        using one cad administrator login account
     -  Users can access SOS Manager using the URL:port for the server
        User authentication is done using the Linux PAM module
```


open docs by typing sosmgr_docs

   This requires information such as:
       - Host to run the web server daemon
       - Port the web server will listen to
       - Symbolic name to identify this design center

   You can configure the web server now or do it later by invoking:
     sosmgr site setup

   Note: The web server is not required if you only plan to use
   the command line interface.
   
- Set the environment variable CLIOSOFT_DIR to point to
  the installation directory for the release + platform.

- Add '$CLIOSOFT_DIR/bin' to your search path.

- To read the release notes and online documentation please type:
    sos_docs

export CLIOSOFT_DIR=/tools/clio/sos_7.20.p1_linux64
export PATH="${CLIOSOFT_DIR}/bin:${PATH}"


  You would need a web browser to view the documentation- preferably firefox.

- If you are a new user and need a license then:
    + login to the machine on which you want to run the 
      FlexLM license server.
    + Get the hostname by running: hostname
    + Get the hostid by running:   $CLIOSOFT_DIR/license/lmhostid
    + Request a license by emailing the hostname and hostid to:
        support@cliosoft.com

- When you have a license file and have setup the license server with it

- If you have a user based license then edit the file:
    $CLIOSOFT_DIR/license/users.lst
  and include the list of users who will use SOS according to the
  instructions in the file $CLIOSOFT_DIR/license/license.dat.

- Invoke the license server by running:
    $CLIOSOFT_DIR/bin/clio_lmstart -c <license> -l <path to license log>

- To test the installation:
    + Login as a real user.
    + Make sure $CLIOSOFT_DIR is set and '$CLIOSOFT_DIR/bin' is 
      added to the search path.
    + Create a temporary directory and cd into it.
    + Invoke SOS by typing: sos

- If you have license related problems then read the <license log> file that was 
  passed as -l option to the clio_lmstart script for diagnostic messages.

- When setting the environment variable $CLIOSOFT_DIR or when specifying
  the pathname for the project database make sure that you do NOT include
  artifacts of the automounter like '/tmp_mnt'.

- After the installation is successful you can delete the installation files.
