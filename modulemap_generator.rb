require 'xcodeproj'
require 'rexml/document'

project = Xcodeproj::Project.open('${SOURCE_ROOT}/Pods/Pods.xcodeproj')

Xcodeproj::XCScheme.share_scheme(project.path, 'Starscream')

scheme = Xcodeproj::XCScheme.new(Xcodeproj::XCScheme.shared_data_dir(project.path) + 'Starscream.xcscheme')
preActions = REXML::Document.new '<PreActions>
<ExecutionAction
   ActionType = "Xcode.IDEStandardExecutionActionsCore.ExecutionActionType.ShellScriptAction">
   <ActionContent
      title = "Run Script"
      scriptText = "mkdir -p &quot;${CONFIGURATION_BUILD_DIR}&quot;&#10;cat &lt;&lt;EOF &gt; &quot;${CONFIGURATION_BUILD_DIR}/Starscream.modulemap&quot;&#10;module SSCZLib [system] {&#10;    header &quot;${SDK_DIR}/usr/include/zlib.h&quot;&#10;    link &quot;z&quot;&#10;    export *&#10;}&#10;module SSCommonCrypto [system] {&#10;    header &quot;${SDK_DIR}/usr/include/CommonCrypto/CommonCrypto.h&quot;&#10;    export *&#10;}&#10;framework module Starscream {&#10;}&#10;EOF">
      <EnvironmentBuildable>
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "33CCF0841F5DDC030099B092"
            BuildableName = "Starscream.framework"
            BlueprintName = "Starscream"
            ReferencedContainer = "container:Starscream.xcodeproj">
         </BuildableReference>
      </EnvironmentBuildable>
   </ActionContent>
</ExecutionAction>
</PreActions>
'
scheme.doc.elements['Scheme/BuildAction'].add_element(preActions)
scheme.save_as(project.path, 'Starscream', true)

project.targets.each do |target|
    if target.name == 'Starscream'
        target.build_configurations.each do |config|
            config.build_settings['MODULEMAP_FILE'] = '${CONFIGURATION_BUILD_DIR}/Starscream.modulemap'
        end
    end
end
project.save()