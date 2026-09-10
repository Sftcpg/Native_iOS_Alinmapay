import SwiftUI

public struct SDKTextField: View {

    private let title: String
    @Binding private var text: String

    private let keyboardType: UIKeyboardType
    private let width: CGFloat?
    private let height: CGFloat
    private let logo: String?
    private let isSecure: Bool
    let style: SDKInputStyle

    private let validation:
        ((String) -> String?)?

    private let onChange:
        ((String) -> Void)?

    @State private var errorMessage:
        String?

    public init(
        title: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        width: CGFloat? = nil,
        height: CGFloat = 44,
        style: SDKInputStyle,
        logo: String? = nil,
        isSecure: Bool = false,
        validation: ((String) -> String?)? = nil,
        onChange: ((String) -> Void)? = nil
        
    )
    {
        self.title = title
        self._text = text
        self.keyboardType = keyboardType
        self.width = width
        self.height = height
        self.style = style
        self.logo = logo
        self.isSecure = isSecure
        self.validation = validation
        self.onChange = onChange
        
    }

    public var body: some View {

        VStack(
            alignment: .leading,
            spacing: 5
        ) {

            HStack {

                if let logo {

                    Image(systemName: logo)
                        .foregroundColor(.gray)
                }

                if isSecure {

                    SecureField(
                        title,
                        text: $text
                    )
                    .keyboardType(
                        keyboardType
                    )
                    .onChange(
                        of: text
                    ) { value in

                        onChange?(value)

                        errorMessage =
                            validation?(value)
                    }

                } else {

                    TextField(
                        title,
                        text: $text
                    )
                    .keyboardType(
                        keyboardType
                    )
                    .onChange(
                        of: text
                    ) { value in

                        onChange?(value)

                        errorMessage =
                            validation?(value)
                    }
                }
            }
            .padding(.horizontal, 12)
            .frame(
                width: width,
                height: height
            )
            .background(
                RoundedRectangle(
                    cornerRadius: style.cornerRadius
                )
                .fill(style.backgroundColor)
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius: style.cornerRadius
                )
                .stroke(
                    errorMessage == nil
                        ? style.borderColor
                        : Color.red,
                    lineWidth: style.borderWidth
                )
            )

            if let errorMessage {

                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(
                        Color.red
                    )
            }
        }
    }
}
