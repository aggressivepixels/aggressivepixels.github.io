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
          code: {
            color: null,
            fontWeight: null,
          },
          'code::before': {
            content: '""',
          },
          'code::after': {
            content: '""',
          },
          'code:not(.hljs)': {
            backgroundColor: theme('colors.gray.200'),
            borderRadius: 3,
            fontSize: 'inherit',
            fontWeight: 'normal',
            paddingBottom: '0.2rem',
            paddingLeft: '0.3rem',
            paddingRight: '0.3rem',
            paddingTop: '0.3rem',
          },
          'pre + h2': {
            marginTop: '1.5em',
          },
          pre: {
            color: null,
            backgroundColor: null,
            padding: 0,
          },
          'pre code': {
            backgroundColor: null,
            color: null,
            paddingTop: '1em',
            paddingBottom: '1em',
            paddingLeft: '1.5em',
            paddingRight: '1.5em',
            borderRadius: '1em',
            borderWidth: 1,
            borderColor: 'rgba(0, 0, 0, 0.1)',
          },
        },
      },
    }),
  },
  variants: {
    typography: [],
    display: ['responsive', 'group-hover'],
  },
  plugins: [
    require('@tailwindcss/typography')({
      modifiers: [],
    }),
  ],
}
