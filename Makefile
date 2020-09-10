.PHONY: run
run: build/vm.raw build/kernel
	qemu-system-x86_64 \
		-machine q35 \
		-accel kvm \
		-m 2048M \
		-kernel build/kernel/vmlinuz-linux \
		-initrd build/kernel/initramfs-linux-fallback.img \
		-append "rw root=/dev/vda rootfstype=ext4" \
		-drive file=build/vm.raw,format=raw,if=virtio \
		-nic user

build/docker.id:
	mkdir -p build
	docker build --network host --iidfile "$@" --no-cache docker

build/vm.raw: build/docker.id
	mkdir -p build
	fallocate -l 2GiB -o 1024 "$@"
	mkfs.ext4 "$@"
	docker run --rm -it --privileged --network=host -v "$(PWD)":/opt "$(shell cat build/docker.id)" /opt/scripts/pacstrap.sh

build/kernel: build/docker.id
	mkdir -p "$@"
	$(eval ID := $(shell docker create "$(shell cat build/docker.id)"))
	docker cp "$(ID)":/boot/vmlinuz-linux "$@/"
	docker cp "$(ID)":/boot/initramfs-linux-fallback.img "$@/"
	docker rm "$(ID)"

clean:
	rm -rf build/
