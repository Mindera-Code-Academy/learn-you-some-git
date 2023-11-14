name = "learn-you-some-git"

all: linux macos windows

linux:
	mkdir -p build/linux-$(name)
	godot --export "Linux" "build/linux-$(name)/$(name)"
	cd build && chmod +x linux-$(name)/$(name) && tar -czf linux-$(name).tar.gz linux-$(name)

macos:
	mkdir -p build
	godot --export "Mac OS" "build/macos-$(name).zip"

windows: dependencies/windows/git/
	mkdir -p build/windows-$(name)
	# We're using the debug template here so that the bash.exe doesn't spawn a cmd.exe each time...
	godot --export-debug "Windows" "build/windows-$(name)/$(name).exe"
	cp -r --parents dependencies/windows/git/ build/windows-$(name)/
	cd build/windows-$(name) && zip -r ../windows-$(name).zip *

clean-unzipped:
	cd build && ls | grep -v '\.zip$$' | xargs rm -r

clean:
	rm -rf build dependencies cache

# Dependencies:

cache/portablegit.7z.exe:
	mkdir -p cache
	wget https://github.com/git-for-windows/git/releases/download/v2.28.0.windows.1/PortableGit-2.28.0-64-bit.7z.exe -O cache/portablegit.7z.exe

dependencies/windows/git/: cache/portablegit.7z.exe
	7zr x cache/portablegit.7z.exe -odependencies/windows/git/ -y
