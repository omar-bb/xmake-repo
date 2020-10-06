package("tmxparser")

    set_homepage("https://github.com/sainteos/tmxparser")
    set_description("C++11 library for parsing the maps generated by Tiled Map Editor")

    set_urls("https://github.com/sainteos/tmxparser.git")
    add_versions("2.2.0", "d314b3115c7ed86a939eefcb6009a495f043a346")

    add_deps("zlib", "tinyxml2")

    on_install(function (package)
        io.gsub("include/Tmx.h.in", "@VERSION_PATCH@", "@VERSION_ALTER@")
        io.writefile("xmake.lua", ([[
            set_version("%s")
            add_requires("zlib", "tinyxml2")
            add_rules("mode.debug", "mode.release")
            target("tmxparser")
                set_kind("$(kind)")
                set_languages("cxx11")
                add_packages("zlib", "tinyxml2")
                add_headerfiles("include/*.h")
                add_includedirs("include", "include/base64")
                set_configdir("include")
                add_configfiles("include/Tmx.h.in", {pattern = "@(.-)@"})
                add_files("src/**.cpp")
        ]]):format(package:version_str()))
        import("package.tools.xmake").install(package, {kind = package:config("shared") and "shared" or "static"})
    end)

    on_test(function (package)
       assert(package:check_cxxsnippets({test = [[
            void test(int argc, char** argv) {
                Tmx::Map map;
                map.ParseFile("test.xml");
            }
        ]]}, {configss = {languages = "c++11"}, includes = "Tmx.h"}))
    end)