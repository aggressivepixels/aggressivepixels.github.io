module.exports = {
  purge: ['./components/**/*.{js,ts,jsx,tsx}', './pages/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {},
    fontFamily: {
      sans: ["'Overpass'", 'sans-serif'],
      mono: ["'Overpass Mono'", 'monospace'],
    },
    typography: (theme) => ({
      default: {
        css: {
          h2: {
            marginTop: '1em',
          },
          h3: {
            marginTop: '0.75em',
            marginBottom: '0.8em',
          },
          'h2 + h3': {
            marginTop: '-0.5em',
          },
          code: {
            backgroundColor: theme('colors.gray.200'),
            borderRadius: 3,
            fontSize: 'inherit',
            fontWeight: 'normal',
            paddingBottom: '0.2rem',
            paddingLeft: '0.3rem',
            paddingRight: '0.3rem',
            paddingTop: '0.3rem',
          },
          'code::before': {
            content: '',
          },
          'code::after': {
            content: '',
          },
          'pre + h2': {
            marginTop: '1.5em',
          },
        },
      },
    }),
  },
  variants: {},
  plugins: [require('@tailwindcss/typography')],
}
