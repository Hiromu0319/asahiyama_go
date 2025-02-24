.PHONY: setup
setup:
	flutter clean
	flutter pub get

.PHONY: build_runner
build_runner:
	flutter pub run build_runner build --delete-conflicting-outputs

# .PHONY: deploy_function
# deploy_function:
#     firebase deploy --only functions