.onLoad <-
function(libname, pkgname)
{
    .jpackage(pkgname, lib.loc = libname)
    ## Weka's dynamic class discovery (used by e.g. the Snowball stemmer
    ## class to locate the snowball jar file in the classpath) triggers
    ## the loading of Weka's packages and makes the KnowledgeFlow
    ## rebuild its internal set of components, causing trouble on
    ## systems without AWT, unless we do the following.
    if(nzchar(Sys.getenv("NOAWT")))
        .jcall("java/lang/System", "S",
               "setProperty", "java.awt.headless", "true")

    ## If the directory given by WEKA_HOME (or its default
    ## $HOME/wekafiles) was not created yet, make sure it gets created
    ## in tempdir().
    if(is.na(isdir <-
             file.info(Sys.getenv("WEKA_HOME",
                                  file.path(path.expand("~"),
                                            "wekafiles")))$isdir) ||
       !isdir)
        Sys.setenv(WEKA_HOME = tempfile("RWeka"))

    ## Instantiate the Weka package manager to that classes in jars in
    ## the Weka jar can be found.
    Weka_package_manager(new_Weka_package_manager())

    ## As of Weka 3.9.1, .jnew() can no longer be used for classes in
    ## external packages.  Hence, instantiate the Weka package class
    ## loader manager and use its objectForName() method instead.
    Weka_package_class_loader_manager(.jnew("weka/core/WekaPackageClassLoaderManager"))
}
